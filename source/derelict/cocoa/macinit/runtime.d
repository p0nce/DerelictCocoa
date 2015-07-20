/*
 * Copyright (c) 2004-2008 Derelict Developers
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
module derelict.sdl.macinit.runtime;

version (darwin):

import derelict.sdl.macinit.string;

version (Tango)
    import tango.stdc.stringz : fromStringz, toStringz;

else
{
    static import std.string;

    alias std.string.toStringz toStringz;
    alias std.string.toString fromStringz;
}

import derelict.sdl.macinit.NSGeometry;
import derelict.util.loader;

package:


alias objc_ivar* Ivar;
alias objc_method* Method;
alias objc_object Protocol;

alias char* SEL;
alias objc_class* Class;
alias objc_object* id;

alias extern (C) id function(id, SEL, ...) IMP;

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
    objc_ivar ivar_list[1];
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
    objc_method method_list[1];
}

struct objc_cache
{
    uint mask /* total = mask + 1 */;
    uint occupied;
    Method buckets[1];
}

struct objc_protocol_list
{
    objc_protocol_list* next;
    long count;
    Protocol* list[1];
}


extern (C)
{
    typedef Class function (Class superclass) pfobjc_registerClassPair;
    pfobjc_registerClassPair objc_registerClassPair;
}

static this ()
{
    SharedLib cocoa = Derelict_LoadSharedLib("Cocoa.framework/Cocoa");
    bindFunc(objc_registerClassPair)("objc_registerClassPair", cocoa);
}

//Objective-C runtime bindings from the Cocoa framework
extern (C)
{
    typedef bool function (Class cls, /*const*/char* name, size_t size, byte alignment, /*const*/char* types) pfclass_addIvar;
    pfclass_addIvar varclass_addIvar;

    typedef bool function (Class cls, SEL name, IMP imp, /*const*/char* types) pfclass_addMethod;
    pfclass_addMethod varclass_addMethod;

    typedef Class function (Class superclass, /*const*/char* name, size_t extraBytes) pfobjc_allocateClassPair;
    pfobjc_allocateClassPair varobjc_allocateClassPair;

    typedef id function (/*const*/char* name) pfobjc_getClass;
    pfobjc_getClass varobjc_getClass;

    typedef id function (/*const*/char* name) pfobjc_lookUpClass;
    pfobjc_lookUpClass varobjc_lookUpClass;

    typedef id function (id theReceiver, SEL theSelector, ...) pfobjc_msgSend;
    pfobjc_msgSend varobjc_msgSend;

    typedef id function (objc_super* superr, SEL op, ...) pfobjc_msgSendSuper;
    pfobjc_msgSendSuper varobjc_msgSendSuper;

    typedef void function (void* stretAddr, id theReceiver, SEL theSelector, ...) pfobjc_msgSend_stret;
    pfobjc_msgSend_stret varobjc_msgSend_stret;

    typedef /*const*/char* function (id obj) pfobject_getClassName;
    pfobject_getClassName varobject_getClassName;

    typedef Ivar function (id obj, /*const*/char* name, void** outValue) pfobject_getInstanceVariable;
    pfobject_getInstanceVariable varobject_getInstanceVariable;

    typedef Ivar function (id obj, /*const*/char* name, void* value) pfobject_setInstanceVariable;
    pfobject_setInstanceVariable varobject_setInstanceVariable;

    typedef SEL function (/*const*/char* str) pfsel_registerName;
    pfsel_registerName varsel_registerName;

    version (X86)
    {
        typedef double function (id self, SEL op, ...) pfobjc_msgSend_fpret;
        pfobjc_msgSend_fpret varobjc_msgSend_fpret;
    }

    typedef  Method function (Class aClass, SEL aSelector) pfclass_getInstanceMethod;
    pfclass_getInstanceMethod varclass_getInstanceMethod;

    typedef IMP function (Method method, IMP imp) pfmethod_setImplementation;
    pfmethod_setImplementation method_setImplementation;

    typedef bool function () pfNSApplicationLoad;
    pfNSApplicationLoad NSApplicationLoad;
}

static this ()
{
    SharedLib cocoa = Derelict_LoadSharedLib("Cocoa.framework/Cocoa");

    bindFunc(varclass_addIvar)("class_addIvar", cocoa);
    bindFunc(varclass_addMethod)("class_addMethod", cocoa);
    bindFunc(varobjc_allocateClassPair)("objc_allocateClassPair", cocoa);
    bindFunc(varobjc_getClass)("objc_getClass", cocoa);
    bindFunc(varobjc_lookUpClass)("objc_lookUpClass", cocoa);
    bindFunc(varobjc_msgSend)("objc_msgSend", cocoa);
    bindFunc(varobjc_msgSendSuper)("objc_msgSendSuper", cocoa);
    bindFunc(varobjc_msgSend_stret)("objc_msgSend_stret", cocoa);
    bindFunc(varobject_getClassName)("object_getClassName", cocoa);
    bindFunc(varobject_getInstanceVariable)("object_getInstanceVariable", cocoa);
    bindFunc(varobject_setInstanceVariable)("object_setInstanceVariable", cocoa);
    bindFunc(varsel_registerName)("sel_registerName", cocoa);

    version (X86) bindFunc(varobjc_msgSend_fpret)("objc_msgSend_fpret", cocoa);

    bindFunc(varclass_getInstanceMethod)("class_getInstanceMethod", cocoa);
    bindFunc(method_setImplementation)("method_setImplementation", cocoa);

    bindFunc(NSApplicationLoad)("NSApplicationLoad", cocoa);
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
