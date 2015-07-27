DerelictCocoa [![Build Status](https://travis-ci.org/p0nce/DerelictCocoa.png?branch=master)](https://travis-ci.org/p0nce/DerelictCocoa)
=============

*Warning: this a VERY bare-bones unofficial Derelict binding.*

A dynamic binding to [Cocoa](https://en.wikipedia.org/wiki/Cocoa_(API)) for the D Programming Language. **This binding is incomplete. Use PR to add more stuff.**

For information on how to build DerelictCocoa and link it with your programs, please see the post [Using Derelict](http://dblog.aldacron.net/derelict-help/using-derelict/) at The One With D.

For information on how to load the Cocoa framework via DerelictCocoa, see the page [DerelictUtil for Users](https://github.com/DerelictOrg/DerelictUtil/wiki/DerelictUtil-for-Users) at the DerelictUtil Wiki. In the meantime, here's some sample code.

```D
void main(string[] args)
{
	// Load the Cocoa framework.
    DerelictCocoa.load();

    // Now Cocoa functions can be called

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
    window.makeKeyAndOrderFront();

    NSApp.activateIgnoringOtherApps(YES);
    NSApp.run();
}

```

