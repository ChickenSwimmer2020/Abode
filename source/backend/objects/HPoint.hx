package backend.objects;

/**
 * openfl.geom.point, but float. with int options.
 * @since 0.00.000
 */
class HPoint {
	public var x:Float = 0;
	public var y:Float = 0;
	public var iX:Int = 0;
	public var iY:Int = 0;

	public function new(x:Float, y:Float) {
		this.x = x;
		this.y = y;
		iX = Math.floor(x);
		iY = Math.floor(y);
	}

	public function set(x:Float, y:Float) {
		this.x = x;
		this.y = y;
		iX = Math.floor(x);
		iY = Math.floor(y);
	}

	public function toOpenflPoint():Point
		return new Point(x, y);

	public static function fromOpenflPoint(p:Point):HPoint
		return new HPoint(p.x, p.y);

	public function toString():String
		return 'HPoint: [$x, $y]';
}
