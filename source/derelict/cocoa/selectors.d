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

__gshared
{
    // Classes
    id class_NSApplication;
    id class_NSAutoreleasePool;
    id class_NSDictionary;
    id class_NSEnumerator;
    id class_NSGeometry;
    id class_NSMenu;
    id class_NSMenuItem;
    id class_NSNotification;
    id class_NSObject;
    id class_NSProcessInfo;
    id class_NSString;
    id class_SDLApplication;

    // Selectors
    string sel_stringWithCharacters_length;
    string sel_addItem;
    string sel_addItemWithTitle_action_keyEquivalent;
    string sel_alloc;
    string sel_class;
    string sel_getCharacters_range;
    string sel_hasSubmenu;
    string sel_init;
    string sel_initWithTitle;
    string sel_itemArray;
    string sel_length;
    string sel_mainMenu;
    string sel_nextObject;
    string sel_objectEnumerator;
    string sel_objectForKey;
    string sel_poseAsClass;
    string sel_processInfo;
    string sel_processName;
    string sel_rangeOfString;
    string sel_release;
    string sel_run;
    string sel_setAppleMenu;
    string sel_setDelegate;
    string sel_setKeyEquivalentModifierMask;
    string sel_setMainMenu;
    string sel_setSubmenu;
    string sel_setTitle;
    string sel_setWindowsMenu;
    string sel_sharedApplication;
    string sel_sizeToFit;
    string sel_stringByAppendingString;
    string sel_submenu;
    string sel_title;
    string sel_UTF8String;
    string sel_separatorItem;
    string sel_stop;
    string sel_terminate;
    string sel_setupWorkingDirectory;
    string sel_application;
    string sel_applicationDidFinishLaunching;
    string sel_initWithTitle_action_keyEquivalent;
}

void loadSelectors()
{
    class_NSApplication = objc_getClass("NSApplication");
    class_NSAutoreleasePool = objc_getClass("NSAutoreleasePool");
    class_NSDictionary = objc_getClass("NSDictionary");
    class_NSEnumerator = objc_getClass("NSEnumerator");
    class_NSGeometry = objc_getClass("NSGeometry");
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

    // Lazy selector literal
    // eg: sel!"init"
    // Not thread-safe
    string sel(string selectorName)()
    {
        __gshared string cached = null;

        if (cached is null)
        {
            cached = registerName(selectorName);
        }       
    }
}
