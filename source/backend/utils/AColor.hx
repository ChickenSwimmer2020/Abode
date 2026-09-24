package backend.utils;

import openfl.geom.ColorTransform;

abstract AColor(Int) from Int from UInt to Int to UInt{
    public static inline var TRANSPARENT:AColor = 0x00000000;
    public static inline var BGDARKEN:AColor = 0xFF3A3A3A;
    public static inline var BLACK:AColor = 0xFF000000;

    //ui related colors
    public static inline var BUTTON_IDLE:AColor = 0xFFFFFF;
    public static inline var BUTTON_HOVER:AColor = 0xA3A3A3;
    public static inline var BUTTON_CLICK:AColor = 0x818181;

    public function new(v:Int=0xFF000000) this=v;
    public static inline function fromInt(v:Int):AColor return new AColor(v);
    public static inline function toTransform(c:AColor):ColorTransform return new ColorTransform((((c>>16)&0xFF)/255),(((c>>8)&0xFF)/255),((c&0xFF)/255),1); //TODO: fix alpha not working.
}