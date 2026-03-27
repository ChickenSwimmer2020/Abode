package backend;

import backend.utils.ATween.AEase;
import backend.utils.ATween.Tween;
import openfl.geom.Matrix;

class LoadingIndicator extends ASprite {
    public var loadingSpeed:Float = 0.4;

    var topLeft:LoadingSegment;
    var topRight:LoadingSegment;
    var bottomRight:LoadingSegment;
    var bottomLeft:LoadingSegment;

    var tween:Tween;
    var segments:Array<LoadingSegment>;
    var currentSegment:Int = 0;

    var destroyed:Bool = false;

    public function new(x:Float, y:Float) {
        super(x, y, null);

        tween = new Tween();
        tween.autoDestroy=false;
        addChild(tween); // ← was missing, tween needs to be on stage to get ENTER_FRAME

        topLeft     = new LoadingSegment(TopLeft);
        topRight    = new LoadingSegment(TopRight);
        bottomRight = new LoadingSegment(BottomRight);
        bottomLeft  = new LoadingSegment(BottomLeft);

        drawOutlines();

        segments = [topLeft, topRight, bottomRight, bottomLeft];
        for (seg in segments) addChild(seg).alpha = 0.3;

        animateNext();
    }

    private function animateNext() {
        if (destroyed) return; // stop the chain
        var seg = segments[currentSegment];
        tween.tween(seg, {alpha: 1.0}, loadingSpeed, () -> {
            if (destroyed) return;
            tween.tween(seg, {alpha: 0.3}, loadingSpeed, () -> {
                if (destroyed) return;
                currentSegment = (currentSegment + 1) % segments.length;
                animateNext();
            }, AEase.quadIn);
        }, AEase.quadOut);
    }

    override public function destroy() {
        destroyed = true; // stop animateNext chain first
        tween.destroy();
        tween = null;
        for (seg in segments) seg.destroy();
        segments = null;
        graphics.clear();
        super.destroy();
    }

    var m = new Matrix();
    function tx(x:Float, y:Float):Float return m.a * x + m.c * y + m.tx;
    function ty(x:Float, y:Float):Float return m.b * x + m.d * y + m.ty;
    private static final PURPLE_SIZE:Int = 6;
    var angle:Float = 45 * (Math.PI / 180);

    private function drawOutlines() {
        var w:Float = 65;
        var h:Float = 65;
        m.translate(-w / 2, -h / 2);
        m.rotate(angle);
        m.translate(w / 2, h / 2);
        graphics.lineStyle(2, 0x000000, 1);
        graphics.beginFill(0x7c58e2, 1);
        graphics.moveTo(tx(0, 0),   ty(0, 0));
        graphics.lineTo(tx(w, 0),   ty(w, 0));
        graphics.lineTo(tx(w, h),   ty(w, h));
        graphics.lineTo(tx(0, h),   ty(0, h));
        graphics.lineTo(tx(0, 0),   ty(0, 0));
        graphics.moveTo(tx(PURPLE_SIZE, PURPLE_SIZE),         ty(PURPLE_SIZE, PURPLE_SIZE));
        graphics.lineTo(tx(w-PURPLE_SIZE, PURPLE_SIZE),       ty(w-PURPLE_SIZE, PURPLE_SIZE));
        graphics.lineTo(tx(w-PURPLE_SIZE, h-PURPLE_SIZE),     ty(w-PURPLE_SIZE, h-PURPLE_SIZE));
        graphics.lineTo(tx(PURPLE_SIZE, h-PURPLE_SIZE),       ty(PURPLE_SIZE, h-PURPLE_SIZE));
        graphics.lineTo(tx(PURPLE_SIZE, PURPLE_SIZE),         ty(PURPLE_SIZE, PURPLE_SIZE));
        graphics.endFill();
    }
}

enum SegmentPosition {
    TopLeft;
    TopRight;
    BottomRight;
    BottomLeft;
}

class LoadingSegment extends ASprite {
    private static final PURPLE_SIZE:Int = 6;
    private static final W:Float = 65;
    private static final H:Float = 65;
    private static final HALF:Float = 65 / 2;

    public function new(pos:SegmentPosition) {
        super(0, 0, null);
        drawSegment(pos);
    }

    private function drawSegment(pos:SegmentPosition) {
        var cx = W / 2;
        var cy = H / 2;
        var points = switch(pos) {
            case TopLeft:     [{x:cx, y:cy}, {x:PURPLE_SIZE, y:PURPLE_SIZE},     {x:HALF, y:PURPLE_SIZE},    {x:PURPLE_SIZE, y:HALF}];
            case TopRight:    [{x:cx, y:cy}, {x:W-PURPLE_SIZE, y:PURPLE_SIZE},   {x:HALF, y:PURPLE_SIZE},    {x:W-PURPLE_SIZE, y:HALF}];
            case BottomRight: [{x:cx, y:cy}, {x:W-PURPLE_SIZE, y:H-PURPLE_SIZE}, {x:HALF, y:H-PURPLE_SIZE},  {x:W-PURPLE_SIZE, y:HALF}];
            case BottomLeft:  [{x:cx, y:cy}, {x:PURPLE_SIZE, y:H-PURPLE_SIZE},   {x:HALF, y:H-PURPLE_SIZE},  {x:PURPLE_SIZE, y:HALF}];
        }

        graphics.lineStyle(1, 0x000000, 1);
        graphics.beginFill(0x7c58e2, 1);
        graphics.moveTo(points[0].x, points[0].y);
        for (i in 1...points.length)
            graphics.lineTo(points[i].x, points[i].y);
        graphics.lineTo(points[0].x, points[0].y);
        graphics.endFill();
    }

    override public function destroy() {
        graphics.clear();
        super.destroy();
    }
}