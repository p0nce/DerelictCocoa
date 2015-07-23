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
import derelict.cocoa.selectors;


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

class NSApplication : NSObject
{
    this ()
    {
        id_ = null;
    }

    this (id id_)
    {
        this.id_ = id_;
    }

    static NSApplication alloc ()
    {
        id result = objc_msgSend(cast(id)class_, sel_alloc);
        return result ? new NSApplication(result) : null;
    }

    static Class class_ ()
    {
        string name = this.classinfo.name;
        size_t index = name.lastIndexOf('.');

        if (index != -1)
            name = name[index + 1 .. $];

        return cast(Class) objc_getClass(name);
    }

    override NSApplication init ()
    {
        id result = objc_msgSend(this.id_, sel_init);
        return result ? this : null;
    }

    public static NSApplication sharedApplication ()
    {
        id result = objc_msgSend(class_NSApplication, sel_sharedApplication);
        return result ? new NSApplication(result) : null;
    }

    NSMenu mainMenu ()
    {
        id result = objc_msgSend(this.id_, sel_mainMenu);
        return result ? new NSMenu(result) : null;
    }

    void setAppleMenu (NSMenu menu)
    {
        objc_msgSend(this.id_, sel_setAppleMenu, menu ? menu.id_ : null);
    }

    void setWindowsMenu (NSMenu menu)
    {
        objc_msgSend(this.id_, sel_setWindowsMenu, menu ? menu.id_ : null);
    }

    void setMainMenu (NSMenu menu)
    {
        objc_msgSend(this.id_, sel_setMainMenu, menu ? menu.id_ : null);
    }

    void setDelegate (ID object)
    {
        objc_msgSend(this.id_, sel_setDelegate, object ? object.id_ : null);
    }

    void run ()
    {
        objc_msgSend(this.id_, sel_run);
    }

    void stop (ID sender)
    {
        objc_msgSend(this.id_, sel_stop, sender ? sender.id_ : null);
    }
}

class NSMenu : NSObject
{
    this ()
    {
        id_ = null;
    }

    this (id id_)
    {
        this.id_ = id_;
    }

    static NSMenu alloc ()
    {
        id result = objc_msgSend(cast(id)class_, sel_alloc);
        return result ? new NSMenu(result) : null;
    }

    static Class class_ ()
    {
        string name = this.classinfo.name;
        size_t index = name.lastIndexOf('.');

        if (index != -1)
            name = name[index + 1 .. $];

        return cast(Class) objc_getClass(name);
    }

    override NSMenu init ()
    {
        id result = objc_msgSend(this.id_, sel_init);
        return result ? this : null;
    }

    NSString title ()
    {
        id result = objc_msgSend(this.id_, sel_title);
        return result ? new NSString(result) : null;
    }

    NSMenu initWithTitle (NSString aTitle)
    {
        id result = objc_msgSend(this.id_, sel_initWithTitle, aTitle ? aTitle.id_ : null);
        return result ? new NSMenu(result) : null;
    }

    void setTitle (NSString str)
    {
        objc_msgSend(this.id_, sel_setTitle, str ? str.id_ : null);
    }

    NSArray itemArray ()
    {
        id result = objc_msgSend(this.id_, sel_itemArray);
        return result ? new NSArray(result) : null;
    }

    void sizeToFit ()
    {
        objc_msgSend(this.id_, sel_sizeToFit);
    }

    NSMenuItem addItemWithTitle (NSString str, string selector, NSString keyEquiv)
    {
        id result = objc_msgSend(this.id_, sel_addItemWithTitle_action_keyEquivalent, str ? str.id_ : null, cast(SEL) selector.ptr, keyEquiv ? keyEquiv.id_ : null);
        return result ? new NSMenuItem(result) : null;
    }

    void addItem (NSMenuItem newItem)
    {
        objc_msgSend(this.id_, sel_addItem, newItem ? newItem.id_ : null);
    }
}

class NSMenuItem : NSObject
{
    this ()
    {
        id_ = null;
    }

    this (id id_)
    {
        this.id_ = id_;
    }

    static NSMenuItem alloc ()
    {
        id result = objc_msgSend(cast(id)class_, sel_alloc);
        return result ? new NSMenuItem(result) : null;
    }

    static Class class_ ()
    {
        string name = this.classinfo.name;
        size_t index = name.lastIndexOf('.');

        if (index != -1)
            name = name[index + 1 .. $];

        return cast(Class) objc_getClass(name);
    }

    override NSMenuItem init ()
    {
        id result = objc_msgSend(this.id_, sel_init);
        return result ? this : null;
    }

    static NSMenuItem separatorItem ()
    {
        id result = objc_msgSend(class_NSMenuItem, sel_separatorItem);
        return result ? new NSMenuItem(result) : null;
    }

    NSMenuItem initWithTitle (NSString itemName, string anAction, NSString charCode)
    {
        id result = objc_msgSend(this.id_, sel_initWithTitle_action_keyEquivalent, itemName ? itemName.id_ : null, sel_registerName(anAction), charCode ? charCode.id_ : null);
        return result ? new NSMenuItem(result) : null;
    }

    NSString title ()
    {
        id result = objc_msgSend(this.id_, sel_title);
        return result ? new NSString(result) : null;
    }

    void setTitle (NSString str)
    {
        objc_msgSend(this.id_, sel_setTitle, str ? str.id_ : null);
    }

    bool hasSubmenu ()
    {
        return objc_msgSend(this.id_, sel_hasSubmenu) !is null;
    }

    NSMenu submenu ()
    {
        id result = objc_msgSend(this.id_, sel_submenu);
        return result ? new NSMenu(result) : null;
    }

    void setKeyEquivalentModifierMask (NSUInteger mask)
    {
        objc_msgSend(this.id_, sel_setKeyEquivalentModifierMask, mask);
    }

    void setSubmenu (NSMenu submenu)
    {
        objc_msgSend(this.id_, sel_setSubmenu, submenu ? submenu.id_ : null);
    }
}

