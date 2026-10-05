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
    public static inline final BUTTON_IDLE:AColor = 0xFFFFFFFF;
    public static inline final BUTTON_HOVER:AColor = 0xFFA3A3A3;
    public static inline final BUTTON_CLICK:AColor = 0xFF818181;
    public static inline final BUTTON_DISABLED:AColor = 0xFF5A5A5A; 


    public function new(v:Int=0xFF000000) this=v;
    public var rgb(get, set):Int;
    public var r(get, set):Float;
    public var g(get, set):Float;
    public var b(get, set):Float;
    public var a(get, set):Float;

    public inline function get_rgb():Int return this & 0xFFFFFF;
    public inline function get_r():Float return (this >> 16) & 0xFF;
    public inline function get_g():Float return (this >> 8) & 0xFF;
    public inline function get_b():Float return this & 0xFF;
    public inline function get_a():Float return ((this >> 24) & 0xFF) / 255;

    public inline function set_rgb(v:Int):Int {
        this = (this & 0xFF000000) | (v & 0xFFFFFF); // keep alpha
        return v;
    }
    public inline function set_r(v:Float):Float {
        this = (this & 0xFF00FFFF) | (_ch(v) << 16);
        return v;
    }
    public inline function set_g(v:Float):Float {
        this = (this & 0xFFFF00FF) | (_ch(v) << 8);
        return v;
    }
    public inline function set_b(v:Float):Float {
        this = (this & 0xFFFFFF00) | _ch(v);
        return v;
    }
    public inline function set_a(v:Float):Float {
        this = (this & 0x00FFFFFF) | (Math.round(Math.max(0, Math.min(1, v)) * 255) << 24);
        return v;
    }

    // clamp a 0-255 channel value and round to an Int
    static inline function _ch(v:Float):Int
        return Math.round(Math.max(0, Math.min(255, v)));
    public inline function toString():String return '[AColor]: rgb:$rgb, r:$r, g:$g, b:$b, a:$a';
    public inline function toHexString():String return '#${Std.string(this).substr(3, Std.string(this).length)}'; //string manip :3
    public static inline function fromInt(v:Int):AColor return new AColor(v);
    public static inline function toTransform(c:AColor):ColorTransform return new ColorTransform(0,0,0,((c>>24)&0xFF)/255,((c>>16)&0xFF),((c>>8)&0xFF),(c&0xFF),0);
}