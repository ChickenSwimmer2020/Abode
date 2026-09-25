package backend.utils;

class DrawUtil {
    public static function addRect(spr:ASprite, rect:Rectangle, color:AColor):ASprite {
        spr.graphics.beginFill(AColor.getRGB(color), color.a);
            spr.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
        spr.graphics.endFill();
        return spr;
    }
}