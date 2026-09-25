package backend.utils;


abstract AColor(Int) from Int from UInt to Int to UInt{
    public static inline final TRANSPARENT:AColor = 0x00000000;
    public static inline final BLACK:AColor = 0xFF000000;
    public static inline final WHITE:AColor = 0xFFFFFFFF;
    public static inline final RED:AColor = 0xFFFF0000;
    public static inline final MAGENTA:AColor = 0xFFFF00FF;

    #if debug
        public static inline final DEBUGGER_BACKGROUND:AColor = 0x99000000;
        public static inline final DEBUGGER_CONSOLE_TEXT:AColor = 0xFF00FF00;
    #end
    //ui related colors
    public static inline final LOADINGIND_MAINCOLOR:AColor = 0xFF7c58e2;
    public static inline final MAINMENU_PROJECTSLIST_DARKEN:AColor = 0x6A000000;
    public static inline final MENUBAR_BACKGROUND:AColor = 0xFF7B7B7B;
    public static inline final MENUBAR_DROPDOWN_BACKGROUND:AColor = 0xFF262626;
    public static inline final MENUBAR_DROPDOWN_SEPERATOR:AColor = 0xFF000000;
    public static inline final BUTTON_IDLE:AColor = 0xFFFFFF;
    public static inline final BUTTON_HOVER:AColor = 0xA3A3A3;
    public static inline final BUTTON_CLICK:AColor = 0x818181;
    public static inline final BUTTON_DISABLED:AColor = 0xFF5A5A5A; 


    public function new(v:Int=0xFF000000) this=v;
    public var r(get, never):Float;
    public var g(get, never):Float;
    public var b(get, never):Float;
    public var a(get, never):Float;
    public inline function get_r():Float return ((this>>16)&0xFF);
    public inline function get_g():Float return ((this>>8)&0xFF);
    public inline function get_b():Float return (this&0xFF);
    public inline function get_a():Float return (((this>>24)&0xFF)==0?1:((this>>24)&0xFF)/255);

    public static inline function getRGB(c:AColor):AColor return c&0xFFFFFF; //bitwise is weird.
    public static inline function fromInt(v:Int):AColor return new AColor(v);
    public static inline function toTransform(c:AColor):ColorTransform return new ColorTransform(0,0,0,(((c>>24)&0xFF)==0?1:((c>>24)&0xFF)/255),((c>>16)&0xFF),((c>>8)&0xFF),(c&0xFF),0);
}