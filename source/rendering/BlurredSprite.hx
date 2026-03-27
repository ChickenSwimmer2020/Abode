package rendering;

import openfl.display.BitmapData;
import openfl.display.Bitmap;
import openfl.display.Sprite;
import openfl.filters.BlurFilter;
import openfl.events.Event;

class BlurredSprite extends Sprite {
    private var cropped:BitmapData;
    private var preBlurred:BitmapData; // pre-blurred version of the full source
    private var sourceBitmap:BitmapData;
    private var _blur:Float;
    private var _quality:Int;
    private var _w:Int;
    private var _h:Int;

    public function new(width:Int, height:Int, color:Int, a:Float, sourceBitmap:BitmapData, blur:Float = 8.0, quality:Int = 2) {
        super();
        _w = width;
        _h = height;
        _blur = blur;
        _quality = quality;
        this.sourceBitmap = sourceBitmap;

        // pre-blur the ENTIRE source once upfront
        preBlurred = sourceBitmap.clone();
        preBlurred.applyFilter(preBlurred, preBlurred.rect, new openfl.geom.Point(0, 0), new BlurFilter(blur, blur, quality));

        cropped = new BitmapData(width, height, false, 0);
        addChild(new Bitmap(cropped));

        var overlay = new Sprite();
        overlay.graphics.beginFill(color, a);
        overlay.graphics.drawRect(0, 0, width, height);
        overlay.graphics.endFill();
        addChild(overlay);

        addEventListener(Event.ADDED_TO_STAGE, onAdded);
    }

    private function onAdded(e:Event):Void {
        removeEventListener(Event.ADDED_TO_STAGE, onAdded);
        stage.addEventListener(Event.ENTER_FRAME, onFirstFrame);
    }

    private function onFirstFrame(e:Event):Void {
        stage.removeEventListener(Event.ENTER_FRAME, onFirstFrame);
        recapture();
    }

    public function recapture():Void {
        if (preBlurred == null) return;
        // just a cheap crop from the pre-blurred bitmap, no applyFilter needed
        var m = new openfl.geom.Matrix();
        m.translate(-x, -y);
        cropped.lock();
        cropped.fillRect(cropped.rect, 0);
        cropped.draw(preBlurred, m);
        cropped.unlock();
    }

    public function setBlur(blur:Float) {
        _blur = blur;
        // re-blur the full source and recrop
        preBlurred.dispose();
        preBlurred = sourceBitmap.clone();
        preBlurred.applyFilter(preBlurred, preBlurred.rect, new openfl.geom.Point(0, 0), new BlurFilter(_blur, _blur, _quality));
        recapture();
    }

    public function destroy():Void {
        if (cropped != null) { cropped.dispose(); cropped = null; }
        if (preBlurred != null) { preBlurred.dispose(); preBlurred = null; }
        sourceBitmap = null;
        if (parent != null) parent.removeChild(this);
    }
}