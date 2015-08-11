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
module derelict.cocoa.cocoa;

version(OSX):

import derelict.util.system;
import derelict.util.loader;

import derelict.cocoa.runtime;
import derelict.cocoa.foundation;
import derelict.cocoa.appkit;

static if(Derelict_OS_Mac)
    enum libNames = "/System/Library/Frameworks/Cocoa.framework/Cocoa";
else
    static assert(0, "Need to implement Cocoa libNames for this operating system.");


class DerelictCocoaLoader : SharedLibLoader
{
    protected
    {
        this()
        {
            super(libNames);
        }

        override void loadSymbols()
        {
            // Runtime
            bindFunc(cast(void**)&objc_registerClassPair, "objc_registerClassPair");
            bindFunc(cast(void**)&varclass_addIvar, "class_addIvar");
            bindFunc(cast(void**)&varclass_addMethod, "class_addMethod");
            bindFunc(cast(void**)&varobjc_allocateClassPair, "objc_allocateClassPair");
            bindFunc(cast(void**)&varobjc_getClass, "objc_getClass");
            bindFunc(cast(void**)&varobjc_lookUpClass, "objc_lookUpClass");
            bindFunc(cast(void**)&varobjc_msgSend, "objc_msgSend");
            bindFunc(cast(void**)&varobjc_msgSendSuper, "objc_msgSendSuper");
            bindFunc(cast(void**)&varobjc_msgSend_stret, "objc_msgSend_stret");
            bindFunc(cast(void**)&varobject_getClassName, "object_getClassName");
            bindFunc(cast(void**)&varobject_getInstanceVariable, "object_getInstanceVariable");
            bindFunc(cast(void**)&varobject_setInstanceVariable, "object_setInstanceVariable");
            bindFunc(cast(void**)&varsel_registerName, "sel_registerName");
          /*  version(X86)*/ bindFunc(cast(void**)&varobjc_msgSend_fpret, "objc_msgSend_fpret");
            bindFunc(cast(void**)&varclass_getInstanceMethod, "class_getInstanceMethod");
            bindFunc(cast(void**)&method_setImplementation, "method_setImplementation");

            // Foundation
            bindFunc(cast(void**)&NSAllocateMemoryPages, "NSAllocateMemoryPages");
            bindFunc(cast(void**)&NSDeallocateMemoryPages, "NSDeallocateMemoryPages");

            // Appkit
            bindFunc(cast(void**)&NSApplicationLoad, "NSApplicationLoad");
        }
    }
}


__gshared DerelictCocoaLoader DerelictCocoa;

shared static this()
{
    DerelictCocoa = new DerelictCocoaLoader;
}

unittest
{
    static if(Derelict_OS_Mac)   
        DerelictCocoa.load();
}
