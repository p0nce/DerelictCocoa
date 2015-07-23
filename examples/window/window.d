import std.stdio;

import derelict.cocoa;


void main(string[] args)
{
	DerelictCocoa.load();

    auto pool = new NSAutoreleasePool;
	
	auto NSApp = NSApplication.sharedApplication;

    NSApp.setActivationPolicy(NSApplicationActivationPolicyRegular);
/+
    NSMenu menubar = new NSMenu;
    NSMenuItem appMenuItem = new NSMenuItem;

    menubar.addItem(appMenuItem);
    NSApp.setMainMenu(menubar);  
   
    NSMenu appMenu = new NSMenu();
    NSString appName = NSProcessInfo.processInfo().processName();

    writefln("appName = %s", appName);
+/

/+
    id quitTitle = [@"Quit " stringByAppendingString:appName];
    id quitMenuItem = [[[NSMenuItem alloc] initWithTitle:quitTitle
        action:@selector(terminate:) keyEquivalent:@"q"] autorelease];
    [appMenu addItem:quitMenuItem];
    [appMenuItem setSubmenu:appMenu];
    +/

    NSWindow window = new NSWindow();
    window.initWithContentRect(NSMakeRect(10, 10, 200, 200), NSBorderlessWindowMask, NSBackingStoreBuffered, false);

/+
    //id window = [[[NSWindow alloc] initWithContentRect:NSMakeRect(0, 0, 200, 200)
    //    styleMask:NSTitledWindowMask backing:NSBackingStoreBuffered defer:NO]
     //       autorelease];
   /* [window cascadeTopLeftFromPoint:NSMakePoint(20,20)];
    [window setTitle:appName];
    [window makeKeyAndOrderFront:nil];
    */
    +/
    NSApp.activateIgnoringOtherApps(true);
    NSApp.run();
   
}