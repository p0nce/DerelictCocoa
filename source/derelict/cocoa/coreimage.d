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
module derelict.cocoa.coreimage;

version(OSX):

import derelict.cocoa.runtime;
import derelict.cocoa.foundation;
import derelict.cocoa.coregraphics;


struct CIContext
{
    NSObject parent;
    alias parent this;

    mixin NSObjectTemplate!(CIContext, "CIContext");

    void drawImage(CIImage image, CGRect inRect, CGRect fromRect)
    {
        objc_msgSend(_id, sel!"drawImage:inRect:fromRect:", image._id, inRect, fromRect);
    }
}

alias CIFormat = int;

extern(C)
{
    __gshared CIFormat kCIFormatARGB8;
    //__gshared CIFormat kCIFormatBGRA8; // iOS only
    //__gshared CIFormat kCIFormatRGBA8; // iOS only
    __gshared CIFormat kCIFormatRGBA16;
    __gshared CIFormat kCIFormatRGBAf;
    __gshared CIFormat kCIFormatRGBAh;
}

struct CIImage
{
    NSObject parent;
    alias parent this;

    mixin NSObjectTemplate!(CIImage, "CIImage");

    static CIImage imageWithBitmapData(NSData d, size_t bytesPerRow, CGSize size, CIFormat f, CGColorSpaceRef cs)
    {
        id result = objc_msgSend(getClassID(),
                                 sel!"imageWithBitmapData:bytesPerRow:size:format:colorSpace:",
                                 d._id, bytesPerRow, size, f, cs);
        return CIImage(result);
    }
}