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
module derelict.cocoa.foundation;

import std.string;
import std.utf;

import derelict.util.loader;
import derelict.util.system;

import derelict.cocoa.runtime;
import derelict.cocoa.selectors;

static if(Derelict_OS_Mac)
    enum libNames = "../Frameworks/Foundation.framework/Foundation, /Library/Frameworks/Foundation.framework/Foundation, /System/Library/Frameworks/Foundation.framework/Foundation";
else static if(Derelict_OS_Windows)
    enum libNames = "dummy (for testing)";
else
    static assert(0, "Need to implement Cocoa libNames for this operating system.");

class DerelictFoundationLoader : SharedLibLoader
{
    protected
    {
        this()
        {
            super(libNames);
        }

        override void loadSymbols()
        {
            // these function can be found either here or in Cocoa... which to use?
            bindFunc(cast(void**)&NSAllocateMemoryPages, "NSAllocateMemoryPages");
            bindFunc(cast(void**)&NSDeallocateMemoryPages, "NSDeallocateMemoryPages");
        }
    }
}

__gshared DerelictFoundationLoader DerelictFoundation;

shared static this()
{
    DerelictFoundation = new DerelictFoundationLoader;
}

// NSZone

extern (C) nothrow @nogc
{
    alias void* function(NSUInteger bytes) pfNSAllocateMemoryPages;
    alias void function (void* ptr, NSUInteger bytes) pfNSDeallocateMemoryPages;
}

__gshared
{
    pfNSDeallocateMemoryPages NSDeallocateMemoryPages;
    pfNSAllocateMemoryPages NSAllocateMemoryPages;
}

unittest
{
    static if(Derelict_OS_Mac)   
        DerelictFoundation.load();
}


class ID
{
    id id_;

    this()
    {
        id_ = null;
    }

    this(id id_)
    {
        this.id_ = id_;
    }
}

class NSObject : ID
{
    this ()
    {
        id_ = null;
    }

    this (id id_)
    {
        this.id_ = id_;
    }

    static NSObject alloc ()
    {
        id result = objc_msgSend(cast(id)class_, sel_alloc);
        return result ? new NSObject(result) : null;
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
        objc_msgSend(class_NSObject, sel_poseAsClass, aClass);
    }

    NSObject init ()
    {
        id result = objc_msgSend(this.id_, sel_init);
        return result ? this : null;
    }

    void release ()
    {
        objc_msgSend(this.id_, sel_release);
    }
}
class NSString : NSObject
{
    this ()
    {
        id_ = null;
    }

    this (id id_)
    {
        this.id_ = id_;
    }

    static NSString alloc ()
    {
        id result = objc_msgSend(cast(id)class_, sel_alloc);
        return result ? new NSString(result) : null;
    }

    static Class class_ ()
    {
        string name = this.classinfo.name;
        size_t index = name.lastIndexOf('.');

        if (index != -1)
            name = name[index + 1 .. $];

        return cast(Class) objc_getClass(name);
    }

    override NSString init ()
    {
        id result = objc_msgSend(this.id_, sel_init);
        return result ? this : null;
    }

    static NSString stringWith (string str)
    {
        id result = objc_msgSend(class_NSString, sel_stringWithCharacters_length, str.toUTF16z(), str.length);
        return result !is null ? new NSString(result) : null;
    }

    static NSString opAssign (string str)
    {
        return stringWith(str);
    }

    NSUInteger length ()
    {
        return cast(NSUInteger) objc_msgSend(this.id_, sel_length);
    }

    /*const*/ char* UTF8String ()
    {
        return cast(/*const*/ char*) objc_msgSend(this.id_, sel_UTF8String);
    }

    void getCharacters (wchar* buffer, NSRange range)
    {
        objc_msgSend(this.id_, sel_getCharacters_range, buffer, range);
    }

    NSString stringWithCharacters (/*const*/ wchar* chars, NSUInteger length)
    {
        id result = objc_msgSend(this.id_, sel_stringWithCharacters_length, chars, length);
        return result ? new NSString(result) : null;
    }

    NSRange rangeOfString (NSString aString)
    {
        return *cast(NSRange*) objc_msgSend(this.id_, sel_rangeOfString, aString ? aString.id_ : null);
    }

    NSString stringByAppendingString (NSString aString)
    {
        id result = objc_msgSend(this.id_, sel_stringByAppendingString, aString ? aString.id_ : null);
        return result ? new NSString(result) : null;
    }

    NSString stringByReplacingRange (NSRange aRange, NSString str)
    {
        int bufferSize;
        int selfLen = cast(int)this.length;
        int aStringLen = cast(int)str.length;
        wchar* buffer;
        NSRange localRange;
        NSString result;

        bufferSize = selfLen + aStringLen - cast(int)aRange.length;
        buffer = cast(wchar*) NSAllocateMemoryPages(bufferSize * wchar.sizeof);

        /* Get first part into buffer */
        localRange.location = 0;
        localRange.length = aRange.location;
        this.getCharacters(buffer, localRange);

        /* Get middle part into buffer */
        localRange.location = 0;
        localRange.length = aStringLen;
        str.getCharacters(buffer + aRange.location, localRange);

        /* Get last part into buffer */
        localRange.location = aRange.location + aRange.length;
        localRange.length = selfLen - localRange.location;
        this.getCharacters(buffer + aRange.location + aStringLen, localRange);

        /* Build output string */
        result = NSString.stringWithCharacters(buffer, bufferSize);

        NSDeallocateMemoryPages(buffer, bufferSize);

        return result;
    }
}

class NSEnumerator : NSObject
{
    this ()
    {
        id_ = null;
    }

    this (id id_)
    {
        this.id_ = id_;
    }

    static NSEnumerator alloc ()
    {
        id result = objc_msgSend(cast(id)class_, sel_alloc);
        return result ? new NSEnumerator(result) : null;
    }

    static Class class_ ()
    {
        string name = this.classinfo.name;
        size_t index = name.lastIndexOf('.');

        if (index != -1)
            name = name[index + 1 .. $];

        return cast(Class) objc_getClass(name);
    }

    override NSEnumerator init ()
    {
        id result = objc_msgSend(this.id_, sel_init);
        return result ? this : null;
    }

    ID nextObject ()
    {
        id result = objc_msgSend(this.id_, sel_nextObject);
        return result ? new ID(result) : null;
    }
}

class NSArray : NSObject
{
    this ()
    {
        id_ = null;
    }

    this (id id_)
    {
        this.id_ = id_;
    }

    static NSArray alloc ()
    {
        id result = objc_msgSend(cast(id)class_, sel_alloc);
        return result ? new NSArray(result) : null;
    }

    static Class class_ ()
    {
        string name = this.classinfo.name;
        size_t index = name.lastIndexOf('.');

        if (index != -1)
            name = name[index + 1 .. $];

        return cast(Class) objc_getClass(name);
    }

    override NSArray init ()
    {
        id result = objc_msgSend(this.id_, sel_init);
        return result ? this : null;
    }

    NSEnumerator objectEnumerator ()
    {
        id result = objc_msgSend(this.id_, sel_objectEnumerator);
        return result ? new NSEnumerator(result) : null;
    }
}


class NSProcessInfo : NSObject
{
    this ()
    {
        id_ = null;
    }

    this (id id_)
    {
        this.id_ = id_;
    }

    static NSProcessInfo alloc ()
    {
        id result = objc_msgSend(cast(id)class_, sel_alloc);
        return result ? new NSProcessInfo(result) : null;
    }

    static Class class_ ()
    {
        string name = this.classinfo.name;
        size_t index = name.lastIndexOf('.');

        if (index != -1)
            name = name[index + 1 .. $];

        return cast(Class) objc_getClass(name);
    }

    override NSProcessInfo init ()
    {
        id result = objc_msgSend(this.id_, sel_init);
        return result ? this : null;
    }

    static NSProcessInfo processInfo ()
    {
        id result = objc_msgSend(class_NSProcessInfo, sel_processInfo);
        return result ? new NSProcessInfo(result) : null;
    }

    NSString processName ()
    {
        id result = objc_msgSend(this.id_, sel_processName);
        return result ? new NSString(result) : null;
    }
}

class NSNotification : NSObject
{
    this ()
    {
        id_ = null;
    }

    this (id id_)
    {
        this.id_ = id_;
    }

    static NSNotification alloc ()
    {
        id result = objc_msgSend(cast(id)class_, sel_alloc);
        return result ? new NSNotification(result) : null;
    }

    static Class class_ ()
    {
        string name = this.classinfo.name;
        size_t index = name.lastIndexOf('.');

        if (index != -1)
            name = name[index + 1 .. $];

        return cast(Class) objc_getClass(name);
    }

    override NSNotification init ()
    {
        id result = objc_msgSend(this.id_, sel_init);
        return result ? this : null;
    }
}