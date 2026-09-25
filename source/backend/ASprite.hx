package backend;


typedef ExtraFilterParams = {
    @:optional var colorTransform:Null<AColor>;
    @:optional var offsets:Null<Rectangle>;
} 


class ASprite extends Sprite implements IHasAttributes<String, Dynamic>{
    public var attributes:Map<String, Dynamic>;

    public function setAttribute(a:String, b:Dynamic):String {
        attributes.set(a, b);
        return a;
    }
    public function getAttribute(a:String):Dynamic {
        return attributes.get(a);
    }
    public function removeAttribute(a:String):Bool {
        return attributes.remove(a);
    }




    /**
     * Color transform of the Sprite, affects sub-objects as well.
     */
    public var color(default, set):AColor = AColor.TRANSPARENT;
    public function set_color(c:AColor):AColor {
        color = c;
        trace(c);
        trace('transform: ${AColor.toTransform(c)}');
        transform.colorTransform = AColor.toTransform(c);
        return c;
    }
    /**
     * scale of the sprite.
     */
    public var scale(default, set):APoint = new APoint(1.0, 1.0);
    /**
     * should the sprite antialias
     */
    public var antialiasing:Bool = true;
    /**
     * frame width of the sprite
     */
    public var frameWidth:Float = 0;
    /**
     * frame height of the sprite
     */
    public var frameHeight:Float = 0;
    @:noCompletion private var gWidth:Int = 0;
    @:noCompletion private var gHeight:Int = 0;
    @:noCompletion private var _bitmapData:BitmapData = null; // track it so we can dispose it later

    /**
     * set the scale of the sprite.
     * @param value scale to set.
     * @return APoint
     */
    public function set_scale(value:APoint):APoint {
        @:bypassAccessor scale.x = value.x;
        @:bypassAccessor scale.y = value.y;
        scaleX = value.x;
        scaleY = value.y;
        return scale;
    }

    /**
     * make a new sprite
     * @param x position
     * @param y position
     * @param graphic image to load
     */
    public function new(x:Float, y:Float, ?graphic:OneOfThree<String, Image, BitmapData>) {
        super();
        attributes = new Map<String, Dynamic>();
        this.x = 0;
        this.y = 0;
        if (graphic != null) loadGraphic(graphic);
        setPosition(x, y);
    }

    /**
     * make a graphic without loading bitmap data.
     * @param width width
     * @param height height
     * @param color AColor
     * @return ASprite
     */
    public function makeGraphic(width:Int, height:Int, color:AColor):ASprite {
        graphics.beginFill(AColor.getRGB(color), color.a);
        graphics.drawRect(0, 0, width, height);
        graphics.endFill();
        gWidth = width;
        gHeight = height;
        return this;
    }

    /**
     * load a graphic
     * @param graphic graphic to make 
     * @param takeOwnership no clue what this does :/
     * @return ASprite
     */
    public function loadGraphic(graphic:OneOfThree<String, Image, BitmapData>, takeOwnership:Bool = false):ASprite {
        // dispose previous bitmap if we own it
        if (_bitmapData != null) {
            _bitmapData.dispose();
            _bitmapData = null;
        }
        graphics.clear();

        var Graphics:BitmapData = new BitmapData(1, 1, false, AColor.WHITE);
        switch (Type.getClass(graphic)) {
            case String:
                Graphics = BitmapData.fromFile(graphic);
                _bitmapData = Graphics; // we own this, so we dispose it later
            case Image:
                Graphics = BitmapData.fromImage(graphic);
                _bitmapData = Graphics;
            case BitmapData:
                Graphics = graphic; // caller owns this, so we dont dispose it
                if(takeOwnership) _bitmapData = Graphics; //sprite auto-disposes later i guess
        }

        graphics.beginBitmapFill(Graphics, new Matrix(), false, antialiasing);
        graphics.drawRect(0, 0, Graphics.width, Graphics.height);
        graphics.endFill();
        frameWidth = Graphics.rect.width;
        frameHeight = Graphics.rect.height;
        gWidth = Math.floor(Graphics.rect.width);
        gHeight = Math.floor(Graphics.rect.height);
        return this;
    }

    /**
     * change the color of the sprite background without affecting sub-objects (hopefully)
     * @param color AColor
     * @return ASprite
     */
    public function setGraphicColor(color:AColor):ASprite {
        makeGraphic(gWidth, gHeight, color);
        return this;
    }

    /**
     * change the graphic size.
     * @param width 
     * @param height 
     */
    public function setGraphicSize(width:Float, height:Float) {
        if (width <= 0 && height <= 0) return;
        var newScaleX:Float = width / frameWidth;
        var newScaleY:Float = height / frameHeight;
        scale.set(newScaleX, newScaleY);
        if (width <= 0) scale.x = newScaleY;
        else if (height <= 0) scale.y = newScaleX;
        gWidth = Math.floor(width);
        gHeight = Math.floor(height);
    }

    /**
     * set position
     * @param x 
     * @param y 
     */
    public function setPosition(x:Float, y:Float) {
        this.x = x + width / 2;
        this.y = y + height / 2;
    }

    /**
     * self explanitory.
     */
    public function destroy() {
        graphics.clear();
        // dispose our bitmap if we own it
        if (_bitmapData != null) {
            _bitmapData.dispose();
            _bitmapData = null;
        }

        if (parent != null)
            parent.removeChild(this);
    }

    /**
     * apply a global filter to the entire sprite.
     * @param filter 
     * @return ASprite
     */
    public function applyFilter(filter:BitmapFilter):ASprite{
        if(filters==null) filters=([]:Array<BitmapFilter>);
        var list = filters.copy(); // filters can be null on some versions, see below
        list.push(filter);
        filters = list; // the assignment is what actually applies it
        trace('Added a global filter to sprite (SPRITE INDEX IN MEMBERS) with a filter index of ${filters.indexOf(filter)}');
        return this;
    }
    /**
     * Remove a global filter from the sprite
     * @param index was filter.
     * @return Bool was the filter removed
     */
    public function removeGlobalFilter(index:Int):Bool return ((filters[index]!=null)?filters.remove(filters[index]):false);

    //these cant be cleared properly, once applied their applied.
    //TODO: find workaround for removing local baked filters.
    //TODO: fix this.
    public function applyLocalFilter(size:Rectangle, filter:BitmapFilter, ?extraParams:ExtraFilterParams):ASprite {
        if (_bitmapData == null) {
            trace('applyLocalFilter: sprite does not own its bitmap, skipping');
            return this;
        }

        var region = size.intersection(_bitmapData.rect);
        if (region.width <= 0 || region.height <= 0) return this;

        // 1. temporary sprite that shows only the region, moved to (0, 0)
        var src = new Sprite();
        var targetBitmap:BitmapData = _bitmapData.clone();
        if(extraParams!=null) {
            if(extraParams.colorTransform!=null) {
                targetBitmap.colorTransform(targetBitmap.rect, AColor.toTransform(extraParams.colorTransform));
            }
        }
        src.graphics.beginBitmapFill(targetBitmap, new Matrix(1, 0, 0, 1, -region.x, -region.y), false, true);
            if(extraParams!=null && extraParams.offsets!=null) {
                src.graphics.drawRect(0+extraParams.offsets.x, 0+extraParams.offsets.y, region.width+extraParams.offsets.width, region.height+extraParams.offsets.height);
            }else src.graphics.drawRect(0, 0, region.width, region.height);
        src.graphics.endFill();




        // 2. the live filter, the same mechanism that works for you globally
        src.filters = [filter];

        // 3. bake the filtered sprite into a temp bitmap
        var tmp = new BitmapData(Std.int(region.width), Std.int(region.height), true, 0);
        tmp.draw(src);

        // 4. write it back where the region came from
        _bitmapData.copyPixels(tmp, tmp.rect, new Point(region.x, region.y), null, null, true);

        // 5. clean up temporaries
        tmp.dispose();
        src.graphics.clear();
        src.filters = null;

        // 6. redraw this sprite's fill so it shows the new pixels
        graphics.clear();
        graphics.beginBitmapFill(_bitmapData, new Matrix(), false, antialiasing);
        graphics.drawRect(0, 0, _bitmapData.width, _bitmapData.height);
        graphics.endFill();
        return this;
    }

    /**
     * check if the sprite contains a point.
     * @param point point to check.
     * @return Bool return new Rectangle(x, y, width, height).containsPoint(point.toOpenflPoint())
     */
    public inline function containsPoint(point:APoint):Bool return new Rectangle(x, y, width, height).containsPoint(point.toOpenflPoint());

    #if sys
    public static function getDesktopWallpaper(maxWidth:Int, maxHeight:Int):BitmapData {
        #if windows
            var original = BitmapData.fromFile('C:\\Users\\${Sys.getEnv("USERNAME")}\\AppData\\Roaming\\Microsoft\\Windows\\Themes\\TranscodedWallpaper');
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
        return BitmapData.fromFile('assets/images/FbutteRautah.png'); //return this as a default fallback.
    }
    #end
}