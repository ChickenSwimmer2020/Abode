package backend;

class LoadingIndicator extends ASprite {
    public var loadingSpeed:Float = 0.4;

    var segment:LoadingSegment;
    var bg:ASprite;
    var destroyed:Bool = false;

    public function new(x:Float, y:Float) {
        super(x, y, null);

        bg = new ASprite(0, 0);
        bg.x = 65/2; // center of the 65x65 box — rotation pivot
        bg.y = 65/2;
        addChild(bg);
        drawOutlines();

        segment = new LoadingSegment();
        segment.x = 65/2;
        segment.y = 65/2;
        addChild(segment);

        spin();
        spinBG();
    }



    
    private function spin() {
        if (destroyed) return;
        segment.rotation = 0;
        
        new ATween().tween(segment, {rotation: 360}, loadingSpeed * 4, ()->spin(), AEase.expoInOut);
    }
    private function spinBG() {
        if(destroyed) return;
        bg.rotation = 0;
        new ATween().tween(bg, {rotation: -90}, loadingSpeed * 2, ()->{spinBG();}, AEase.expoOut);
    }

    override public function destroy() {
        destroyed = true; // stop the spin chain first
        segment.destroy();
        segment = null;
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
        var cx = w / 2;
        var cy = h / 2;

        m.translate(-w / 2, -h / 2);
        m.rotate(angle);
        m.translate(w / 2, h / 2);

        // shift every drawn point by (-cx, -cy) so the shape is centered on bg's local (0,0)
        bg.graphics.lineStyle(2, AColor.getRGB(AColor.BLACK), 1);
        bg.graphics.beginFill(AColor.getRGB(AColor.LOADINGIND_MAINCOLOR), AColor.LOADINGIND_MAINCOLOR.a);
        bg.graphics.moveTo(tx(0, 0)-cx,   ty(0, 0)-cy);
        bg.graphics.lineTo(tx(w, 0)-cx,   ty(w, 0)-cy);
        bg.graphics.lineTo(tx(w, h)-cx,   ty(w, h)-cy);
        bg.graphics.lineTo(tx(0, h)-cx,   ty(0, h)-cy);
        bg.graphics.lineTo(tx(0, 0)-cx,   ty(0, 0)-cy);
        bg.graphics.moveTo(tx(PURPLE_SIZE, PURPLE_SIZE)-cx,         ty(PURPLE_SIZE, PURPLE_SIZE)-cy);
        bg.graphics.lineTo(tx(w-PURPLE_SIZE, PURPLE_SIZE)-cx,       ty(w-PURPLE_SIZE, PURPLE_SIZE)-cy);
        bg.graphics.lineTo(tx(w-PURPLE_SIZE, h-PURPLE_SIZE)-cx,     ty(w-PURPLE_SIZE, h-PURPLE_SIZE)-cy);
        bg.graphics.lineTo(tx(PURPLE_SIZE, h-PURPLE_SIZE)-cx,       ty(PURPLE_SIZE, h-PURPLE_SIZE)-cy);
        bg.graphics.lineTo(tx(PURPLE_SIZE, PURPLE_SIZE)-cx,         ty(PURPLE_SIZE, PURPLE_SIZE)-cy);
        bg.graphics.endFill();
    }
}

class LoadingSegment extends ASprite {
    private static final PURPLE_SIZE:Int = 6;
    private static final W:Float = 65;
    private static final H:Float = 65;
    private static final HALF:Float = 65 / 2;

    public function new() {
        super(0, 0, null);
        drawSegment();
    }

    // Wedge shape drawn relative to (0,0) so that Sprite.rotation
    // spins it around the box's actual center, not its corner.
    private function drawSegment() {
        var cx = W / 2;
        var cy = H / 2;
        var points = [
            {x: 0,                y: 0},
            {x: PURPLE_SIZE - cx, y: PURPLE_SIZE - cy},
            {x: HALF - cx,        y: PURPLE_SIZE - cy},
            {x: PURPLE_SIZE - cx, y: HALF - cy}
        ];

        graphics.lineStyle(1, AColor.getRGB(AColor.BLACK), 1);
        graphics.beginFill(AColor.getRGB(AColor.LOADINGIND_MAINCOLOR), AColor.LOADINGIND_MAINCOLOR.a);
        graphics.moveTo(points[0].x+(W/5), points[0].y+(H/5));
        for (i in 1...points.length)
            graphics.lineTo(points[i].x+(W/5), points[i].y+(H/5));
        graphics.lineTo(points[0].x+(W/5), points[0].y+(H/5));
        graphics.endFill();
    }

    override public function destroy() {
        graphics.clear();
        super.destroy();
    }
}