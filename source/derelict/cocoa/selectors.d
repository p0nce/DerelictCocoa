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
module derelict.cocoa.selectors;

import derelict.cocoa.runtime;

// Lazy selector literal
// eg: sel!"init"
// Not thread-safe
SEL sel(string selectorName)()
{
    __gshared SEL cached = null;

    if (cached is null)
    {
        cached = sel_registerName(selectorName);
    }       
    return cached;
}

__gshared
{
    // Classes
    id class_NSApplication;
    id class_NSAutoreleasePool;
    id class_NSDictionary;
    id class_NSEnumerator;
    id class_NSMenu;
    id class_NSMenuItem;
    id class_NSNotification;
    id class_NSObject;
    id class_NSProcessInfo;
    id class_NSString;
    id class_SDLApplication;

    // Selectors
    SEL sel_stringWithCharacters_length;
    SEL sel_addItem;
    SEL sel_addItemWithTitle_action_keyEquivalent;
    SEL sel_alloc;
    SEL sel_class;
    SEL sel_getCharacters_range;
    SEL sel_hasSubmenu;
    SEL sel_init;
    SEL sel_initWithTitle;
    SEL sel_itemArray;
    SEL sel_length;
    SEL sel_mainMenu;
    SEL sel_nextObject;
    SEL sel_objectEnumerator;
    SEL sel_objectForKey;
    SEL sel_poseAsClass;
    SEL sel_processInfo;
    SEL sel_processName;
    SEL sel_rangeOfString;
    SEL sel_release;
    SEL sel_run;
    SEL sel_setAppleMenu;
    SEL sel_setDelegate;
    SEL sel_setKeyEquivalentModifierMask;
    SEL sel_setMainMenu;
    SEL sel_setSubmenu;
    SEL sel_setTitle;
    SEL sel_setWindowsMenu;
    SEL sel_sharedApplication;
    SEL sel_sizeToFit;
    SEL sel_stringByAppendingString;
    SEL sel_submenu;
    SEL sel_title;
    SEL sel_UTF8String;
    SEL sel_separatorItem;
    SEL sel_stop;
    SEL sel_terminate;
    SEL sel_setupWorkingDirectory;
    SEL sel_application;
    SEL sel_applicationDidFinishLaunching;
    SEL sel_setApplicationPolicy;
    SEL sel_initWithTitle_action_keyEquivalent;
}

void loadSelectors()
{
    class_NSApplication = objc_getClass("NSApplication");
    class_NSAutoreleasePool = objc_getClass("NSAutoreleasePool");
    class_NSDictionary = objc_getClass("NSDictionary");
    class_NSEnumerator = objc_getClass("NSEnumerator");
    class_NSMenu = objc_getClass("NSMenu");
    class_NSMenuItem = objc_getClass("NSMenuItem");
    class_NSNotification = objc_getClass("NSNotification");
    class_NSObject = objc_getClass("NSObject");
    class_NSProcessInfo = objc_getClass("NSProcessInfo");
    class_NSString = objc_getClass("NSString");

    sel_stringWithCharacters_length = sel_registerName("stringWithCharacters:length:");
    sel_addItem = sel_registerName("addItem:");
    sel_addItemWithTitle_action_keyEquivalent = sel_registerName("addItemWithTitle:action:keyEquivalent:");
    sel_alloc = sel_registerName("alloc");
    sel_class = sel_registerName("class");
    sel_getCharacters_range = sel_registerName("getCharacters:range:");
    sel_hasSubmenu = sel_registerName("hasSubmenu");
    sel_init = sel_registerName("init");
    sel_initWithTitle = sel_registerName("initWithTitle:");
    sel_itemArray = sel_registerName("itemArray");
    sel_length = sel_registerName("length");
    sel_mainMenu = sel_registerName("mainMenu");
    sel_nextObject = sel_registerName("nextObject");
    sel_objectEnumerator = sel_registerName("objectEnumerator");
    sel_objectForKey = sel_registerName("objectForKey:");
    sel_poseAsClass = sel_registerName("poseAsClass:");
    sel_processInfo = sel_registerName("processInfo");
    sel_processName = sel_registerName("processName");
    sel_rangeOfString = sel_registerName("rangeOfString");
    sel_release = sel_registerName("release");
    sel_run = sel_registerName("run");
    sel_setAppleMenu = sel_registerName("setAppleMenu:");
    sel_setDelegate = sel_registerName("setDelegate:");
    sel_setKeyEquivalentModifierMask = sel_registerName("setKeyEquivalentModifierMask:");
    sel_setMainMenu = sel_registerName("setMainMenu:");
    sel_setSubmenu = sel_registerName("setSubmenu:");
    sel_setTitle = sel_registerName("setTitle:");
    sel_setWindowsMenu = sel_registerName("setWindowsMenu:");
    sel_sharedApplication = sel_registerName("sharedApplication");
    sel_sizeToFit = sel_registerName("sizeToFit");
    sel_stringByAppendingString = sel_registerName("stringByAppendingString:");
    sel_submenu = sel_registerName("submenu");
    sel_title = sel_registerName("title");
    sel_UTF8String = sel_registerName("UTF8String");
    sel_separatorItem = sel_registerName("separatorItem");
    sel_stop = sel_registerName("stop:");
    sel_terminate = sel_registerName("terminate:");
    sel_setupWorkingDirectory = sel_registerName("setupWorkingDirectory");
    sel_application = sel_registerName("application:openFile:");
    sel_applicationDidFinishLaunching = sel_registerName("applicationDidFinishLaunching:");
    sel_initWithTitle_action_keyEquivalent = sel_registerName("initWithTitle:action:keyEquivalent:");
}
