/*
 * SDLMain.m - main entry point for our Cocoa-ized SDL app
 * Initial Version: Darrell Walisser <dwaliss1@purdue.edu>
 * Non-NIB-Code & other changes: Max Horn <max@quendi.de>
 * Port to the D programming language: Jacob Carlborg <jacob.carlborg@gmail.com>
 *
 * Feel free to customize this file to suit your needs
 */
module derelict.sdl.macinit.SDLMain;

version (darwin)
{

private
{

    version (Tango)
        import tango.stdc.posix.unistd;

    else
        import std.c.linux.linux;

    import derelict.sdl.events;
    import derelict.sdl.macinit.CoreFoundation;
    import derelict.sdl.macinit.ID;
    import derelict.sdl.macinit.MacTypes;
    import derelict.sdl.macinit.NSApplication;
    import derelict.sdl.macinit.NSAutoreleasePool;
    import derelict.sdl.macinit.NSDictionary;
    import derelict.sdl.macinit.NSEnumerator;
    import derelict.sdl.macinit.NSEvent;
    import derelict.sdl.macinit.NSGeometry;
    import derelict.sdl.macinit.NSMenu;
    import derelict.sdl.macinit.NSMenuItem;
    import derelict.sdl.macinit.NSNotification;
    import derelict.sdl.macinit.NSObject;
    import derelict.sdl.macinit.NSProcessInfo;
    import derelict.sdl.macinit.NSString;
    import derelict.sdl.macinit.runtime;
    import derelict.sdl.macinit.selectors;
    import derelict.sdl.macinit.string;
    import derelict.util.loader;
}


private const int MAXPATHLEN = 1024; // from sys/param.h

/* Use this flag to determine whether we use CPS (docking) or not */
version = SDL_USE_CPS;

version (SDL_USE_CPS)
{
    struct CPSProcessSerNum
    {
        uint lo;
        uint hi;
    }

    extern (C)
    {
        typedef OSErr function (CPSProcessSerNum *psn) pfCPSGetCurrentProcess;
        pfCPSGetCurrentProcess CPSGetCurrentProcess;

        typedef OSErr function (CPSProcessSerNum *psn, UInt32 _arg2, UInt32 _arg3, UInt32 _arg4, UInt32 _arg5) pfCPSEnableForegroundOperation;
        pfCPSEnableForegroundOperation CPSEnableForegroundOperation;

        typedef OSErr function (CPSProcessSerNum *psn) pfCPSSetFrontProcess;
        pfCPSSetFrontProcess CPSSetFrontProcess;
    }

    static this ()
    {
        SharedLib coreServices = Derelict_LoadSharedLib("Cocoa.framework/Cocoa");

        bindFunc(CPSGetCurrentProcess)("CPSGetCurrentProcess", coreServices);
        bindFunc(CPSEnableForegroundOperation)("CPSEnableForegroundOperation", coreServices);
        bindFunc(CPSSetFrontProcess)("CPSSetFrontProcess", coreServices);
    }
}

else
    version = NO_SDL_USE_CPS;

private
{
    NSAutoreleasePool pool;
    SDLMain sdlMain;
}

static this ()
{
    registerSubclasses;
}

static ~this()
{
    if(pool !is null)
        pool.release();

    if(sdlMain !is null)
        sdlMain.release;
}

private void registerSubclasses ()
{
    Class clazz;

    clazz = objc_allocateClassPair(cast(Class) class_NSApplication, "SDLApplication", 0);
    class_addMethod(clazz, sel_terminate, cast(IMP) &terminate, "v@:");
    objc_registerClassPair(clazz);

    clazz = objc_allocateClassPair(cast(Class) class_NSObject, "SDLMain", 0);
    class_addMethod(clazz, sel_setupWorkingDirectory, cast(IMP) &setupWorkingDirectory, "v@:B");

    class_addMethod(clazz, sel_application, cast(IMP) &application, "B@:@@");
    class_addMethod(clazz, sel_applicationDidFinishLaunching, cast(IMP) &applicationDidFinishLaunching, "v@:@");
    objc_registerClassPair(clazz);

    class_SDLApplication = objc_getClass("SDLApplication");
}

private NSString getApplicationName ()
{
    NSDictionary dict;
    NSString appName;

    /* Determine the application name */
    dict = new NSDictionary(cast(id)CFBundleGetInfoDictionary(CFBundleGetMainBundle()));

    if (dict)
        appName = cast(NSString) dict.objectForKey(NSString.stringWith("CFBundleName"));

    if (appName is null || !appName.length)
        appName = NSProcessInfo.processInfo.processName;

    return appName;
}

class SDLApplication : NSApplication
{
    this ()
    {
        id_ = null;
    }

    this (id id_)
    {
        this.id_ = id_;
    }

    static SDLApplication alloc ()
    {
        id result = objc_msgSend(cast(id)class_, sel_alloc);
        return result ? new SDLApplication(result) : null;
    }

    static Class class_ ()
    {
        string name = this.classinfo.name;
        size_t index = name.lastIndexOf('.');

        if (index != -1)
            name = name[index + 1 .. $];

        return cast(Class) objc_getClass(name);
    }

    static void poseAsClass (Class aClass)
    {
        objc_msgSend(class_SDLApplication, sel_poseAsClass, aClass);
    }

    SDLApplication init ()
    {
        id result = objc_msgSend(this.id_, sel_init);
        return result ? this : null;
    }

    /* Invoked from the Quit menu item */
    void terminate ()
    {
        objc_msgSend(this.id_, sel_terminate);
    }
}

/* Invoked from the Quit menu item */
extern (C) id terminate (id self, SEL selector)
{
    /* Post a SDL_QUIT event */
    SDL_Event event;
    event.type = SDL_QUIT;
    SDL_PushEvent(&event);

    return null;
}

/* The main class of the application, the application's delegate */
class SDLMain : NSObject
{
    this ()
    {
        id_ = null;
    }

    this (id id_)
    {
        this.id_ = id_;
    }

    static SDLMain alloc ()
    {
        id result = objc_msgSend(cast(id)class_, sel_alloc);
        return result ? new SDLMain(result) : null;
    }

    static Class class_ ()
    {
        string name = this.classinfo.name;
        size_t index = name.lastIndexOf('.');

        if (index != -1)
            name = name[index + 1 .. $];

        return cast(Class) objc_getClass(name);
    }

    SDLMain init ()
    {
        id result = objc_msgSend(this.id_, sel_init);
        return result ? this : null;
    }

    void setupWorkingDirectory (bool shouldChdir)
    {
        objc_msgSend(this.id_, sel_setupWorkingDirectory, shouldChdir);
    }

    bool application (NSApplication theApplication, NSString filename)
    {
        return objc_msgSend(this.id_, sel_application, theApplication ? theApplication.id_ : null, filename ? filename.id_ : null) !is null;
    }

    /* Called when the internal event loop has just started running */
    void applicationDidFinishLaunching (NSNotification note)
    {
        objc_msgSend(this.id_, sel_applicationDidFinishLaunching, note ? note.id_ : null);
    }
}

extern (C)
{
    id setupWorkingDirectory (id sender, SEL selector, bool shouldChdir)
    {
        if (shouldChdir)
        {
            char parentdir[MAXPATHLEN];

            CFURLRef url = CFBundleCopyBundleURL(CFBundleGetMainBundle());
            CFURLRef url2 = CFURLCreateCopyDeletingLastPathComponent(null, url);

            if (CFURLGetFileSystemRepresentation(url2, true, cast(ubyte*) parentdir, MAXPATHLEN))
                assert (chdir(parentdir.ptr) == 0);   /* chdir to the binary app's parent */

            CFRelease(url);
            CFRelease(url2);
        }

        return null;
    }

    id application (id sender, SEL selector, id arg0, id arg1)
    {

        return cast(id) true;
    }

    /* Called when the internal event loop has just started running */
    id applicationDidFinishLaunching (id sender, SEL selector, id arg0)
    {
        NSNotification note = arg0 ? new NSNotification(arg0) : null;

        int status;

        /* Set the working directory to the .app's parent directory */
        setupWorkingDirectory(sender, selector, false);

        NSApp.stop(null);

        return null;
    }
}

private void setApplicationMenu ()
{
    /* warning: this code is very odd */
    NSMenu appleMenu;
    NSMenuItem menuItem;
    NSString title;
    NSString appName;

    appName = getApplicationName();
    appleMenu = NSMenu.alloc.initWithTitle(NSString.stringWith(""));

    /* Add menu items */
    title = NSString.stringWith("About ").stringByAppendingString(appName);
    appleMenu.addItemWithTitle(title, sel_registerName("orderFrontStandardAboutPanel:"), NSString.stringWith(""));

    appleMenu.addItem(NSMenuItem.separatorItem);

    title = NSString.stringWith("Hide ").stringByAppendingString(appName);
    appleMenu.addItemWithTitle(title, sel_registerName("hide:"), NSString.stringWith("h"));

    menuItem = appleMenu.addItemWithTitle(NSString.stringWith("Hide Others"), sel_registerName("hideOtherApplications:"), NSString.stringWith("h"));
    menuItem.setKeyEquivalentModifierMask(NSAlternateKeyMask | NSCommandKeyMask);

    appleMenu.addItemWithTitle(NSString.stringWith("Show All"), sel_registerName("unhideAllApplications:"), NSString.stringWith(""));

    appleMenu.addItem(NSMenuItem.separatorItem);

    title = NSString.stringWith("Quit ").stringByAppendingString(appName);
    appleMenu.addItemWithTitle(title, sel_registerName("terminate:"), NSString.stringWith("q"));


    /* Put menu into the menubar */
    menuItem = NSMenuItem.alloc.initWithTitle(NSString.stringWith(""), null, NSString.stringWith(""));
    menuItem.setSubmenu = appleMenu;
    NSApp.mainMenu.addItem(menuItem);

    /* Tell the application object that this is now the application menu */
    NSApp.setAppleMenu = appleMenu;

    /* Finally give up our references to the objects */
    appleMenu.release;
    menuItem.release;
}

/* Create a window menu */
private void setupWindowMenu ()
{
    NSMenu windowMenu;
    NSMenuItem windowMenuItem;
    NSMenuItem menuItem;

    windowMenu = NSMenu.alloc.initWithTitle(NSString.stringWith("Window"));

    /* "Minimize" item */
    menuItem = NSMenuItem.alloc.initWithTitle(NSString.stringWith("Minimize"), "performMiniaturize:", NSString.stringWith("m"));
    windowMenu.addItem(menuItem);
    menuItem.release;

    /* Put menu into the menubar */
    windowMenuItem = NSMenuItem.alloc.initWithTitle(NSString.stringWith("Window"), null, NSString.stringWith(""));
    windowMenuItem.setSubmenu = windowMenu;
    NSApp.mainMenu.addItem(windowMenuItem);

    /* Tell the application object that this is now the window menu */
    NSApp.setWindowsMenu = windowMenu;

    /* Finally give up our references to the objects */
    windowMenu.release;
    windowMenuItem.release;
}

/* Replacement for NSApplicationMain */
private void CustomApplicationMain ()
{
    pool = NSAutoreleasePool.alloc.init;

    /* Ensure the application object is initialised */
    SDLApplication.sharedApplication;

    version (SDL_USE_CPS)
    {
        CPSProcessSerNum PSN;

        /* Tell the dock about us */
        if (!CPSGetCurrentProcess(&PSN))
            if (!CPSEnableForegroundOperation(&PSN, 0x03, 0x3C, 0x2C, 0x1103))
                if (!CPSSetFrontProcess(&PSN))
                    SDLApplication.sharedApplication;
    }

    /* Set up the menubar */
    NSApp.setMainMenu = NSMenu.alloc.init;
    setApplicationMenu();
    setupWindowMenu();


    /* Create SDLMain and make it the app delegate */
    sdlMain = SDLMain.alloc.init;
    NSApp.setDelegate = sdlMain;

    /* Start the main event loop */
    NSApp.run;
}


public void macInit ()
{
    CustomApplicationMain();
}




} // version(darwin)