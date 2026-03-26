package backend;

import openfl.geom.Matrix;
import backend.utils.APoint;
import openfl.display.BitmapData;
import lime.graphics.Image;
import backend.utils.Type.OneOfThree;
import openfl.display.Sprite;

/**
 * ASprite is a sprite, but re-wrapped to have syntax like a FlxSprite. as well as a few features from that including screenCenter, but re-written to use specifically openfl things.
 */
class ASprite extends Sprite {
    public var scale(default, set):APoint=new APoint(1.0, 1.0);
    public var antialiasing:Bool=true; 
    public var frameWidth:Float=0;
    public var frameHeight:Float=0;

    public function set_scale(value:APoint):APoint {
        @:bypassAccessor scale.x = value.x; //i probably DONT need to do this, but im gonna to be safe.
        @:bypassAccessor scale.y = value.y;
        scaleX=value.x;
        scaleY=value.y;
        return scale;
    }

    public function new(x:Float,y:Float,?graphic:OneOfThree<String, Image, BitmapData>) {
        super();
        this.x=0;
        this.y=0;
        if(graphic!=null) loadGraphic(graphic); //funnily enough, FlxSprite does this too.
        setPosition(x, y);
    }

    public function makeGraphic(width:Int, height:Int, color:Int):ASprite {
        graphics.beginFill(color&0x00FFFFFF,(color>>0)&0xFF);
        graphics.drawRect(0, 0, width, height);
        graphics.endFill();

        return this;
    }

    public function loadGraphic(graphic:OneOfThree<String, Image, BitmapData>):ASprite {
        var Graphics:BitmapData = new BitmapData(1, 1, false, 0xFFFFFFFF);
        switch(Type.getClass(graphic)) {
            case String: Graphics = BitmapData.fromFile(graphic);
            case Image: Graphics = BitmapData.fromImage(graphic);
            case BitmapData: Graphics = graphic; //because its already BitmapData.
        }
        graphics.beginBitmapFill(Graphics, new Matrix(), false, antialiasing);
        graphics.drawRect(0, 0, Graphics.width, Graphics.height);  // dont know why i didnt think of doing this, this is kinda important :/
        graphics.endFill();
        frameWidth = Graphics.rect.width;
        frameHeight = Graphics.rect.height;

        trace('sprite width: $width sprite height: $height graphic width: ${Graphics.rect.width} graphic height: ${Graphics.rect.height}');
		return this;
    }

	public function setGraphicSize(width:Float, height:Float) {
		if(width<=0&&height<=0)return;
		var newScaleX:Float = width / frameWidth;
		var newScaleY:Float = height / frameHeight;
		scale.set(newScaleX, newScaleY);

		if (width <= 0) scale.x = newScaleY;
		else if (height <= 0) scale.y = newScaleX;
	}

    public function setPosition(x:Float,y:Float){
        //WOW, soooo i have to emulate positioning systems of flixel since APPARENTLY, openfl has origins in the center of a Sprite, and not the top left corner.
        this.x=x+width/2;
        this.y=y+height/2;
    }
}