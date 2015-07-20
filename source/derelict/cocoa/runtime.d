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

struct NSSize
{
    CGFloat width;
    CGFloat height;
}


// Below is internal use only
package:

alias Ivar = objc_ivar*;
alias Method = objc_method*;
alias Protocol = objc_object;

alias SEL = char*;
alias Class = objc_class*;
alias id = objc_object*;

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
    int versionn;
    int info;
    int instance_size;
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
    alias bool function (Class cls, SEL name, IMP imp, const(char)* types) pfclass_addMethod;
    alias Class function (Class superclass, const(char)* name, size_t extraBytes) pfobjc_allocateClassPair;
    alias id function (/*const*/char* name) pfobjc_getClass;
    alias id function (/*const*/char* name) pfobjc_lookUpClass;
    alias id function (id theReceiver, SEL theSelector, ...) pfobjc_msgSend;
    alias id function (objc_super* superr, SEL op, ...) pfobjc_msgSendSuper;
    alias void function (void* stretAddr, id theReceiver, SEL theSelector, ...) pfobjc_msgSend_stret;
    alias const(char)* function (id obj) pfobject_getClassName;
    alias Ivar function (id obj, /*const*/char* name, void** outValue) pfobject_getInstanceVariable;
    alias Ivar function (id obj, /*const*/char* name, void* value) pfobject_setInstanceVariable;
    alias SEL function (/*const*/char* str) pfsel_registerName;
    version (X86)
        alias double function (id self, SEL op, ...) pfobjc_msgSend_fpret;

    alias  Method function (Class aClass, SEL aSelector) pfclass_getInstanceMethod;
    alias IMP function (Method method, IMP imp) pfmethod_setImplementation;
    alias bool function () pfNSApplicationLoad;
}

__gshared
{
    pfobjc_registerClassPair objc_registerClassPair;

    pfclass_addIvar varclass_addIvar;
    pfclass_addMethod varclass_addMethod;
    pfobjc_allocateClassPair varobjc_allocateClassPair;
    pfobjc_getClass varobjc_getClass;
    pfobjc_lookUpClass varobjc_lookUpClass;
    pfobjc_msgSend varobjc_msgSend;
    pfobjc_msgSendSuper varobjc_msgSendSuper;
    pfobjc_msgSend_stret varobjc_msgSend_stret;
    pfobject_getClassName varobject_getClassName;
    pfobject_getInstanceVariable varobject_getInstanceVariable;
    pfobject_setInstanceVariable varobject_setInstanceVariable;
    pfsel_registerName varsel_registerName;

    version (X86)
        pfobjc_msgSend_fpret varobjc_msgSend_fpret;

    pfclass_getInstanceMethod varclass_getInstanceMethod;
    pfmethod_setImplementation method_setImplementation;
    pfNSApplicationLoad NSApplicationLoad;
}

bool class_addIvar (Class cls, string name, size_t size, byte alignment, string types)
{
    return varclass_addIvar(cls, name.ptr, size, alignment, types.ptr);
}

bool class_addMethod (Class cls, string name, IMP imp, string types)
{
    return varclass_addMethod(cls, name.ptr, imp, types.ptr);
}

Class objc_allocateClassPair (Class superclass, string name, size_t extraBytes)
{
    return varobjc_allocateClassPair(superclass, name.ptr, extraBytes);
}

id objc_getClass (string name)
{
    return varobjc_getClass(name.ptr);
}

id objc_lookUpClass (string name)
{
    return varobjc_lookUpClass(name.ptr);
}

string object_getClassName (id obj)
{
    return fromStringz(varobject_getClassName(obj));
}

Ivar object_getInstanceVariable (id obj, string name, void** outValue)
{
    return varobject_getInstanceVariable(obj, name.ptr, outValue);
}

Ivar object_setInstanceVariable (id obj, string name, void* value)
{
    return varobject_setInstanceVariable(obj, name.ptr, value);
}

string sel_registerName (string str)
{
    return fromStringz(varsel_registerName(str.ptr));
}

id objc_msgSend (ARGS...)(id theReceiver, string theSelector, ARGS args)
{
    return varobjc_msgSend(theReceiver, theSelector.ptr, args);
}

void objc_msgSend_stret (T, ARGS...)(T* stretAddr, id theReceiver, string theSelector, ARGS args)
{
    varobjc_msgSend_stret(stretAddr, theReceiver, theSelector.ptr, args);
}

id objc_msgSendSuper (ARGS...)(objc_super* superr, string op, ARGS args)
{
    return varobjc_msgSendSuper(superr, op.ptr, args);
}

version (X86)
{
    double objc_msgSend_fpret(ARGS...)(id self, string op, ARGS args)
    {
        return varobjc_msgSend_fpret(self, op.ptr, args);
    }
}

Method class_getInstanceMethod (Class aClass, string aSelector)
{
    return varclass_getInstanceMethod(aClass, aSelector.ptr);
}



static if(Derelict_OS_Mac)
    enum libNames = "../Frameworks/Cocoa.framework/Cocoa, /Library/Frameworks/Cocoa.framework/Cocoa, /System/Library/Frameworks/Cocoa.framework/Cocoa";
else
    static assert(0, "Need to implement Cocoa libNames for this operating system.");


class DerelictObjCRuntimeLoader : SharedLibLoader
{
    protected
    {
        this()
        {
            super(libNames);
        }

        override void loadSymbols()
        {
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
            version(X86) bindFunc(cast(void**)&varobjc_msgSend_fpret, "objc_msgSend_fpret");
            bindFunc(cast(void**)&varclass_getInstanceMethod, "class_getInstanceMethod");
            bindFunc(cast(void**)&method_setImplementation, "method_setImplementation");
            bindFunc(cast(void**)&NSApplicationLoad, "NSApplicationLoad");
        }
    }
}


__gshared DerelictObjCRuntimeLoader DerelictObjCRuntime;

shared static this()
{
    DerelictObjCRuntime = new DerelictObjCRuntimeLoader;
}

