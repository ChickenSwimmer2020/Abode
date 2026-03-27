package backend;

import sys.FileSystem;
import openfl.geom.Matrix;
import backend.utils.APoint;
import openfl.display.BitmapData;
import lime.graphics.Image;
import backend.utils.Type.OneOfThree;
import openfl.display.Sprite;

class ASprite extends Sprite {
    public var scale(default, set):APoint = new APoint(1.0, 1.0);
    public var antialiasing:Bool = true;
    public var frameWidth:Float = 0;
    public var frameHeight:Float = 0;

    private var _bitmapData:BitmapData = null; // track it so we can dispose it later

    public function set_scale(value:APoint):APoint {
        @:bypassAccessor scale.x = value.x;
        @:bypassAccessor scale.y = value.y;
        scaleX = value.x;
        scaleY = value.y;
        return scale;
    }

    public function new(x:Float, y:Float, ?graphic:OneOfThree<String, Image, BitmapData>) {
        super();
        this.x = 0;
        this.y = 0;
        if (graphic != null) loadGraphic(graphic);
        setPosition(x, y);
    }

    public function makeGraphic(width:Int, height:Int, color:Int, a:Float):ASprite {
        graphics.beginFill(color, a);
        graphics.drawRect(0, 0, width, height);
        graphics.endFill();
        return this;
    }

    public function loadGraphic(graphic:OneOfThree<String, Image, BitmapData>):ASprite {
        // dispose previous bitmap if we own it
        if (_bitmapData != null) {
            _bitmapData.dispose();
            _bitmapData = null;
        }
        graphics.clear();

        var Graphics:BitmapData = new BitmapData(1, 1, false, 0xFFFFFFFF);
        switch (Type.getClass(graphic)) {
            case String:
                Graphics = BitmapData.fromFile(graphic);
                _bitmapData = Graphics; // we own this, so we dispose it later
            case Image:
                Graphics = BitmapData.fromImage(graphic);
                _bitmapData = Graphics;
            case BitmapData:
                Graphics = graphic; // caller owns this, so we dont dispose it
        }

        graphics.beginBitmapFill(Graphics, new Matrix(), false, antialiasing);
        graphics.drawRect(0, 0, Graphics.width, Graphics.height);
        graphics.endFill();
        frameWidth = Graphics.rect.width;
        frameHeight = Graphics.rect.height;

        return this;
    }

    public function setGraphicSize(width:Float, height:Float) {
        if (width <= 0 && height <= 0) return;
        var newScaleX:Float = width / frameWidth;
        var newScaleY:Float = height / frameHeight;
        scale.set(newScaleX, newScaleY);
        if (width <= 0) scale.x = newScaleY;
        else if (height <= 0) scale.y = newScaleX;
    }

    public function setPosition(x:Float, y:Float) {
        this.x = x + width / 2;
        this.y = y + height / 2;
    }

    public function destroy() {
        // dispose our bitmap if we own it
        if (_bitmapData != null) {
            _bitmapData.dispose();
            _bitmapData = null;
        }
        graphics.clear();

        if (parent != null)
            parent.removeChild(this);
    }

    #if sys
    public static function getDesktopWallpaper(maxWidth:Int, maxHeight:Int):BitmapData {
        #if windows
        var process = new sys.io.Process('reg', [
            'query',
            'HKCU\\Control Panel\\Desktop',
            '/v',
            'WallPaper'
        ]);
        var output = process.stdout.readAll().toString();
        process.close();

        var path = "";
        for (line in output.split("\n")) {
            line = StringTools.trim(line);
            if (StringTools.startsWith(line, "WallPaper")) {
                var parts = ~/\s{2,}/g.split(line);
                if (parts.length >= 3)
                    path = StringTools.trim(parts[2]);
            }
        }

        if (path == "" || !FileSystem.exists(path))
            return null;

        var original = BitmapData.fromFile(path);
        if (original == null) return null;

        var scaleX = maxWidth / original.width;
        var scaleY = maxHeight / original.height;
        var scale = Math.min(scaleX, scaleY);
        var newWidth = Std.int(original.width * scale);
        var newHeight = Std.int(original.height * scale);
        var scaled = new BitmapData(newWidth, newHeight, false, 0);
        var m = new Matrix();
        m.scale(scale, scale);
        scaled.draw(original, m, null, null, null, true);
        original.dispose(); // always dispose the 4k original
        return scaled;
        #end
        return null;
    }
    #end
}