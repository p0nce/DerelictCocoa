import derelict.cocoa;


void main(string[] args)
{
	DerelictCocoa.load();

    NSAutoreleasePool pool = NSAutoreleasePool.alloc.init;
	
	NSApplication NSApp = NSApplication.sharedApplication;

    NSApp.setActivationPolicy(NSApplicationActivationPolicyRegular);

    NSMenu menubar = NSMenu.alloc.init;
    NSMenuItem appMenuItem = NSMenuItem.alloc.init;

    menubar.addItem(appMenuItem);
    NSApp.setMainMenu(menubar);
  
/+    
    id appMenu = [[NSMenu new] autorelease];
    id appName = [[NSProcessInfo processInfo] processName];
    id quitTitle = [@"Quit " stringByAppendingString:appName];
    id quitMenuItem = [[[NSMenuItem alloc] initWithTitle:quitTitle
        action:@selector(terminate:) keyEquivalent:@"q"] autorelease];
    [appMenu addItem:quitMenuItem];
    [appMenuItem setSubmenu:appMenu];
    +/
/+
    NSWindow window = NSWindow.alloc.init;
    window.initWithContentRect(NSMakeRect(0, 0, 200, 200));
    window.styleMask(NSTitledWindowMask);
    window.backing(NSBackingStoreBuffered);
    window.defer(NO);

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