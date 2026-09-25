package backend.objects;

/**
 * simply because openfl.geom.Point is INT based, and i need floating point number.
 * probably the most simple class within all of the program lol.
 */
class APoint {
    public var x:Float=0;
    public var y:Float=0;
    public var iX:Int=0;
    public var iY:Int=0;
    public function new(x:Float,y:Float) {
        this.x=x;
        this.y=y;
        iX = Math.floor(x);
        iY = Math.floor(y);
    }
    public function set(x:Float,y:Float) {
        this.x=x;
        this.y=y;
        iX = Math.floor(x);
        iY = Math.floor(y);
    }
    public function toOpenflPoint():Point return new Point(x, y);


    public function toString():String return 'APoint: [$x, $y]';
}