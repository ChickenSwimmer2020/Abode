package backend.utils;

class ArrayUtil {
    public static function allTrue(a:Array<Bool>):Bool {
        for(b in a) if(!b) return false;
        return true;
    }
}