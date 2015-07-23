import std.stdio;

import derelict.cocoa;


void main(string[] args)
{
    DerelictCocoa.load();

    NSString appName = NSProcessInfo.processInfo().processName();
    writefln("appName = %s", appName);

    auto pool = new NSAutoreleasePool;

    auto NSApp = NSApplication.sharedApplication;

    NSApp.setActivationPolicy(NSApplicationActivationPolicyRegular);

    NSMenu menubar = new NSMenu;
    NSMenuItem appMenuItem = new NSMenuItem;
    menubar.addItem(appMenuItem);
    NSApp.setMainMenu(menubar);

    NSWindow window = NSWindow.alloc();
    window.initWithContentRect(NSMakeRect(10, 10, 200, 200), NSBorderlessWindowMask, NSBackingStoreBuffered, NO);

    NSApp.activateIgnoringOtherApps(YES);
    NSApp.run();
}