package backend.utils;

class AMath {
    public static inline function lerp(a:Float, b:Float, c:Float):Float return (a+c*(b-a));
    public static inline function bound(a:Float,?b:Float,?c:Float):Float return ((c!=null&&(((b!=null&&a<b)?b:a)>c))?c:((b!=null&&a<b)?b:a));
    public static inline function even(n:Float):Bool return ((Std.int(n)&1)==0);
}