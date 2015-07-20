module derelict.cocoa.foundation;



import derelict.util.loader;
import derelict.util.system;

static if(Derelict_OS_Mac)
{
    enum libNames = "../Frameworks/Foundation.framework/Foundation, /Library/Frameworks/Foundation.framework/Foundation, /System/Library/Frameworks/Foundation.framework/Foundation";
}
else
    static assert(0, "Need to implement OpenCL libNames for this operating system.");



__gshared DerelictFoundationLoader DerelictFoundation;

shared static this()
{
    DerelictFoundation = new DerelictFoundationLoader;
}