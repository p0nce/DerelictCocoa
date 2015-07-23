/*
* Copyright (c) 2004-2015 Derelict Developers
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are
* met:
*
* * Redistributions of source code must retain the above copyright
*   notice, this list of conditions and the following disclaimer.
*
* * Redistributions in binary form must reproduce the above copyright
*   notice, this list of conditions and the following disclaimer in the
*   documentation and/or other materials provided with the distribution.
*
* * Neither the names 'Derelict', 'DerelictSDL', nor the names of its contributors
*   may be used to endorse or promote products derived from this software
*   without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
* "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
* TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
* PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
* CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
* EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
* PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
* PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
* LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
* NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
* SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
module derelict.cocoa.appkit;

import std.string;

import derelict.cocoa.runtime;
import derelict.cocoa.foundation;


// Is this useful?

/*
extern(C) pure nothrow
{
    alias int function(int argc, const(char)**argv) pfNSApplicationMain;
}

__gshared
{
    pfNSApplicationMain NSApplicationMain;
}

static this ()
{
    SharedLib cocoa = Derelict_LoadSharedLib("Cocoa.framework/Cocoa");

    NSApp = NSApplication.sharedApplication;
    bindFunc(NSApplicationMain)("NSApplicationMain", cocoa);
}*/



enum
{
    NSAlphaShiftKeyMask = 1 << 16,
    NSShiftKeyMask = 1 << 17,
    NSControlKeyMask = 1 << 18,
    NSAlternateKeyMask = 1 << 19,
    NSCommandKeyMask = 1 << 20,
    NSNumericPadKeyMask = 1 << 21,
    NSHelpKeyMask = 1 << 22,
    NSFunctionKeyMask = 1 << 23,
    NSDeviceIndependentModifierFlagsMask = 0xffff0000U
}

alias NSApplicationActivationPolicy = NSInteger;
enum : NSApplicationActivationPolicy
{
   NSApplicationActivationPolicyRegular = 0,
   NSApplicationActivationPolicyAccessory = 1,
   NSApplicationActivationPolicyProhibited = 2 
}

class NSApplication : NSObject
{
    mixin NSObjectTemplate!(NSApplication, "NSApplication");

    public static NSApplication sharedApplication ()
    {
        id result = objc_msgSend(lazyClass!"NSApplication", sel!"sharedApplication");
        return result ? new NSApplication(result) : null;
    }

    NSMenu mainMenu ()
    {
        id result = objc_msgSend(_id, sel!"mainMenu");
        return result ? new NSMenu(result) : null;
    }

    void setAppleMenu (NSMenu menu)
    {
        objc_msgSend(_id, sel!"setAppleMenu:", menu.toID);
    }

    void setWindowsMenu (NSMenu menu)
    {
        objc_msgSend(_id, sel!"setWindowsMenu:", menu.toID);
    }

    void setMainMenu (NSMenu menu)
    {
        objc_msgSend(_id, sel!"setMainMenu:", menu.toID);
    }

    void setDelegate (id object)
    {
        objc_msgSend(_id, sel!"setDelegate:", object.id);
    }

    void setActivationPolicy(NSApplicationActivationPolicy policy)
    {
        objc_msgSend(_id, sel!"setActivationPolicy:", policy);
    }

    void activateIgnoringOtherApps(BOOL b)
    {
        objc_msgSend(_id, sel!"activateIgnoringOtherApps:", b);
    }

    void run ()
    {
        objc_msgSend(_id, sel!"run");
    }

    void stop (id sender)
    {
        objc_msgSend(_id, sel!"stop:", sender);
    }
}

class NSMenu : NSObject
{
    mixin NSObjectTemplate!(NSMenu, "NSMenu");

    NSString title ()
    {
        id result = objc_msgSend(_id, sel!"title");
        return result ? new NSString(result) : null;
    }

    NSMenu initWithTitle (NSString aTitle)
    {
        id result = objc_msgSend(_id, sel!"initWithTitle:", aTitle.toID);
        return result ? new NSMenu(result) : null;
    }

    void setTitle (NSString str)
    {
        objc_msgSend(_id, sel!"setTitle:", str.toID);
    }

    NSArray itemArray ()
    {
        id result = objc_msgSend(_id, sel!"itemArray");
        return result ? new NSArray(result) : null;
    }

    void sizeToFit ()
    {
        objc_msgSend(_id, sel!"sizeToFit");
    }

    NSMenuItem addItemWithTitle (NSString str, string selector, NSString keyEquiv)
    {
        id result = objc_msgSend(_id, sel!"addItemWithTitle:action:keyEquivalent:", str.toID, cast(SEL) selector.ptr, keyEquiv.toID);
        return result ? new NSMenuItem(result) : null;
    }

    void addItem (NSMenuItem newItem)
    {
        objc_msgSend(_id, sel!"addItem:", newItem.toID);
    }
}

class NSMenuItem : NSObject
{
    mixin NSObjectTemplate!(NSMenuItem, "NSMenuItem");

    static NSMenuItem separatorItem ()
    {
        id result = objc_msgSend(lazyClass!"NSMenuItem", sel!"separatorItem");
        return result ? new NSMenuItem(result) : null;
    }

    NSMenuItem initWithTitle (NSString itemName, string anAction, NSString charCode)
    {
        id result = objc_msgSend(_id, sel!"initWithTitle:action:keyEquivalent:", itemName.toID, sel_registerName(anAction), charCode.toID);
        return result ? new NSMenuItem(result) : null;
    }

    NSString title ()
    {
        id result = objc_msgSend(_id, sel!"title");
        return result ? new NSString(result) : null;
    }

    void setTitle (NSString str)
    {
        objc_msgSend(_id, sel!"setTitle:", str.toID);
    }

    bool hasSubmenu ()
    {
        return objc_msgSend(_id, sel!"hasSubmenu") !is null;
    }

    NSMenu submenu ()
    {
        id result = objc_msgSend(_id, sel!"submenu");
        return result ? new NSMenu(result) : null;
    }

    void setKeyEquivalentModifierMask (NSUInteger mask)
    {
        objc_msgSend(_id, sel!"setKeyEquivalentModifierMask:", mask);
    }

    void setSubmenu (NSMenu submenu)
    {
        objc_msgSend(_id, sel!"setSubmenu:", submenu.toID);
    }
}

// NSResponder

class NSResponder : NSObject
{
    mixin NSObjectTemplate!(NSResponder, "NSResponder");
}


// NSView

alias NSBorderType = NSUInteger;
enum : NSBorderType
{
   NSNoBorder     = 0,
   NSLineBorder   = 1,
   NSBezelBorder  = 2,
   NSGrooveBorder = 3
}

class NSView : NSObject
{
    mixin NSObjectTemplate!(NSView, "NSView");
}


// NSWindow

alias NSBackingStoreType = NSUInteger;
enum : NSBackingStoreType
{
    NSBackingStoreRetained     = 0,
    NSBackingStoreNonretained  = 1,
    NSBackingStoreBuffered     = 2
}

enum : NSUInteger 
{
   NSBorderlessWindowMask = 0,
   NSTitledWindowMask = 1 << 0,
   NSClosableWindowMask = 1 << 1,
   NSMiniaturizableWindowMask = 1 << 2,
   NSResizableWindowMask = 1 << 3,
   NSTexturedBackgroundWindowMask = 1 << 8
}

class NSWindow : NSResponder
{
    mixin NSObjectTemplate!(NSWindow, "NSWindow");

    void initWithContentRect(NSRect contentRect)
    {
        objc_msgSend(_id, sel!"initWithContentRect:", contentRect);
    }

    void initWithContentRect(NSRect contentRect, NSUInteger windowStyle, NSBackingStoreType bufferingType, BOOL deferCreation)
    {
        objc_msgSend(_id, sel!"initWithContentRect:styleMask:backing:defer:", contentRect, windowStyle, bufferingType, deferCreation);
    }

    NSView contentView()
    {
        id result = objc_msgSend(_id, sel!"contentView");
        return result ? new NSView(result) : null;
    }

    void makeKeyAndOrderFront()
    {
        objc_msgSend(_id, sel!"makeKeyAndOrderFront:");
    }
}