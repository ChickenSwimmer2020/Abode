package backend.utils;

/**
 * simply because openfl.geom.Point is INT based, and i need floating point number.
 * probably the most simple class within all of the program lol.
 */
class APoint {
    public var x:Float=0;
    public var y:Float=0;
    public function new(x:Float,y:Float) {
        this.x=x;
        this.y=y;
    }
    public function set(x:Float,y:Float) {
        this.x=x;
        this.y=y;
    }
}