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
module derelict.cocoa.runtime;


/// Important reading: The "OS X ABI Function Call Guide"
/// https://developer.apple.com/library/mac/documentation/DeveloperTools/Conceptual/LowLevelABI/

version(OSX):

import core.stdc.config;
import std.string;

import derelict.util.loader;


// NSGeometry.h

alias NSInteger = ptrdiff_t;
alias NSUInteger = size_t;

static if ((void*).sizeof > int.sizeof) // 64bit
    alias CGFloat = double;
else
    alias CGFloat = float;

struct NSPoint
{
    CGFloat x;
    CGFloat y;
}

struct NSRange
{
    NSUInteger location;
    NSUInteger length;
}

struct NSRect
{
    NSPoint origin;
    NSSize size;
}

NSRect NSMakeRect(CGFloat x, CGFloat y, CGFloat w, CGFloat h)
{
    return NSRect(NSPoint(x, y), NSSize(w, h));
}

struct NSSize
{
    CGFloat width;
    CGFloat height;
}

alias SEL = char*;
alias Class = objc_class*;
alias id = objc_object*;


alias BOOL = char;
enum : BOOL
{
    NO = 0,
    YES = 1
}

alias Ivar = objc_ivar*;
alias Method = objc_method*;
alias Protocol = objc_object;



alias IMP = extern (C) id function(id, SEL, ...);

struct objc_object
{
    Class isa;
}

struct objc_super
{
    id receiver;
    Class clazz;
}

struct objc_class
{
    Class isa;
    Class super_class;
    const char* name;
    c_long versionn;
    c_long info;
    c_long instance_size;
    objc_ivar_list* ivars;
    objc_method_list** methodLists;
    objc_cache* cache;
    objc_protocol_list* protocols;
}

struct objc_ivar
{
    char* ivar_name;
    char* ivar_type;
    int ivar_offset;

    version (X86_64)
        int space;
}

struct objc_ivar_list
{
    int ivar_count;

    version (X86_64)
        int space;

    /* variable length structure */
    objc_ivar[1] ivar_list;
}

struct objc_method
{
    SEL method_name;
    char* method_types;
    IMP method_imp;
}

struct objc_method_list
{
    objc_method_list* obsolete;

    int method_count;

    version (X86_64)
        int space;

    /* variable length structure */
    objc_method[1] method_list;
}

struct objc_cache
{
    uint mask /* total = mask + 1 */;
    uint occupied;
    Method[1] buckets;
}

struct objc_protocol_list
{
    objc_protocol_list* next;
    long count;
    Protocol*[1] list;
}

//Objective-C runtime bindings from the Cocoa framework
extern (C) nothrow @nogc
{
    alias Class function (Class superclass) pfobjc_registerClassPair;

    alias bool function (Class cls, const(char)* name, size_t size, byte alignment, const(char)* types) pfclass_addIvar;
    alias bool function (Class cls, const(SEL) name, IMP imp, const(char)* types) pfclass_addMethod;
    alias Class function (Class superclass, const(char)* name, size_t extraBytes) pfobjc_allocateClassPair;
    alias void function(Class cls) pfobjc_disposeClassPair;
    alias id function (const(char)* name) pfobjc_getClass;
    alias id function (const(char)* name) pfobjc_lookUpClass;

    alias id function (id theReceiver, SEL theSelector, ...) pfobjc_msgSend;
    alias id function (objc_super* superr, SEL op, ...) pfobjc_msgSendSuper;
    alias void function (void* stretAddr, id theReceiver, SEL theSelector, ...) pfobjc_msgSend_stret;

    alias const(char)* function (id obj) pfobject_getClassName;
    alias Ivar function (id obj, const(char)* name, void** outValue) pfobject_getInstanceVariable;
    alias Ivar function (id obj, const(char)* name, void* value) pfobject_setInstanceVariable;
    alias SEL function (const(char)* str) pfsel_registerName;
 //   version (X86)
        alias double function (id self, SEL op, ...) pfobjc_msgSend_fpret;

    alias Method function (Class aClass, const(SEL) aSelector) pfclass_getInstanceMethod;
    alias IMP function (Method method, IMP imp) pfmethod_setImplementation;


    // like pfobjc_msgSend except for returning NSPoint
    alias NSPoint function (id theReceiver, const(SEL) theSelector, ...) pfobjc_msgSend_NSPointret;
}

__gshared
{
    pfobjc_registerClassPair objc_registerClassPair;

    pfclass_addIvar varclass_addIvar;
    pfclass_addMethod varclass_addMethod;
    pfobjc_allocateClassPair varobjc_allocateClassPair;
    pfobjc_disposeClassPair objc_disposeClassPair;
    pfobjc_getClass varobjc_getClass;
    pfobjc_lookUpClass varobjc_lookUpClass;

    pfobjc_msgSend objc_msgSend;
    pfobjc_msgSendSuper objc_msgSendSuper;
    pfobjc_msgSend_stret objc_msgSend_stret;
    pfobjc_msgSend_fpret objc_msgSend_fpret;

    pfobject_getClassName varobject_getClassName;
    pfobject_getInstanceVariable varobject_getInstanceVariable;
    pfobject_setInstanceVariable varobject_setInstanceVariable;
    pfsel_registerName varsel_registerName;


    pfclass_getInstanceMethod varclass_getInstanceMethod;
    pfmethod_setImplementation method_setImplementation;
}

bool class_addIvar (Class cls, string name, size_t size, byte alignment, string types)
{
    return varclass_addIvar(cls, name.ptr, size, alignment, types.ptr);
}

bool class_addMethod (Class cls, SEL name, IMP imp, string types)
{
    return varclass_addMethod(cls, name, imp, types.ptr);
}

Class objc_allocateClassPair (Class superclass, const(char)* name, size_t extraBytes)
{
    return varobjc_allocateClassPair(superclass, name, extraBytes);
}

id objc_getClass (string name)
{
    import std.stdio;
    id result = varobjc_getClass(toStringz(name));

    if (result is null)
        throw new Exception("objc_getClass failed with class " ~ name);

    return result;
}

id objc_lookUpClass (string name)
{
    return varobjc_lookUpClass(name.ptr);
}

string object_getClassName (id obj)
{
    return fromStringz(varobject_getClassName(obj)).idup;
}

Ivar object_getInstanceVariable (id obj, string name, void** outValue)
{
    return varobject_getInstanceVariable(obj, name.ptr, outValue);
}

Ivar object_setInstanceVariable (id obj, string name, void* value)
{
    return varobject_setInstanceVariable(obj, name.ptr, value);
}

SEL sel_registerName (string str)
{
    return varsel_registerName(str.ptr);
}

Method class_getInstanceMethod (Class aClass, string aSelector)
{
    return varclass_getInstanceMethod(aClass, aSelector.ptr);
}

// Lazy selector literal
// eg: sel!"init"
// Not thread-safe!
SEL sel(string selectorName)()
{
    static SEL cached = null; // cached is TLS

    if (cached is null)
    {
        cached = sel_registerName(selectorName);
    }
    return cached;
}

// Lazy class object
// eg: lazyClass!"NSObject"
// Not thread-safe!
id lazyClass(string className)()
{
    static id cached = null; // cached is TLS

    if (cached is null)
    {
        cached = objc_getClass(className);
    }
    return cached;
}

// @encode replacement
template encode(T)
{
    static if (is(T == int))
        enum encode = "i";
    else static if (is(T == NSRect))
    {
        enum encode = "{_NSRect={_NSPoint=dd}{_NSSize=dd}}";
    }
}