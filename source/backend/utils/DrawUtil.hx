package backend.utils;

class DrawUtil {
    public static function addRect(spr:ASprite, rect:Rectangle, color:AColor):ASprite {
        spr.graphics.beginFill(color.rgb, color.a);
            spr.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
        spr.graphics.endFill();
        return spr;
    }

    public static function drawIcon(spr:ASprite, icon:String, thickness:Int, outlineColor:AColor, fillColor:AColor):ASprite {
        if(!Reflect.hasField(ADrawableIcons, icon)) {
            trace('Unrecognized icon $icon, aborting!');
            return spr;
        }
        spr.reRender(); //reRender graphic so that the icon is cleared.
        spr.graphics.lineStyle(thickness, outlineColor.rgb, outlineColor.a);
        spr.graphics.beginFill(fillColor.rgb, fillColor.a);
            for(command in (Reflect.field(ADrawableIcons, icon):Array<ADrawableIconCommand>)) {
                switch(command.t) {
                    case MOVE: spr.graphics.moveTo(command.a.x, command.a.y);
                    case LINE: spr.graphics.lineTo(command.a.x, command.a.y);
                }
            }
        spr.graphics.endFill();
        return spr;
    }
}

enum ADrawableIconCommandType {MOVE; LINE;}
typedef ADrawableIconCommand = {t:ADrawableIconCommandType,a:{x:Int, y:Int}}; 
/**
    do **NOT** make these manually.
    use the utility.
    Abode\Tools\ADrawableIconGen.html in your browser.
 */
class ADrawableIcons {
    public static final SOUND:Array<ADrawableIconCommand> = [
        {t:MOVE, a:{x:7, y:5}},
        {t:LINE, a:{x:7, y:14}},
        {t:LINE, a:{x:3, y:11}},
        {t:LINE, a:{x:3, y:8}},
        {t:LINE, a:{x:7, y:5}},
        {t:MOVE, a:{x:9, y:3}},
        {t:LINE, a:{x:11, y:4}},
        {t:LINE, a:{x:12, y:7}},
        {t:LINE, a:{x:12, y:11}},
        {t:LINE, a:{x:11, y:14}},
        {t:LINE, a:{x:9, y:16}},
        {t:LINE, a:{x:10, y:14}},
        {t:LINE, a:{x:11, y:11}},
        {t:LINE, a:{x:11, y:7}},
        {t:LINE, a:{x:10, y:4}},
        {t:LINE, a:{x:9, y:3}},
        {t:MOVE, a:{x:12, y:1}},
        {t:LINE, a:{x:14, y:2}},
        {t:LINE, a:{x:16, y:6}},
        {t:LINE, a:{x:16, y:12}},
        {t:LINE, a:{x:15, y:15}},
        {t:LINE, a:{x:12, y:17}},
        {t:LINE, a:{x:14, y:15}},
        {t:LINE, a:{x:15, y:12}},
        {t:LINE, a:{x:15, y:6}},
        {t:LINE, a:{x:13, y:2}},
        {t:LINE, a:{x:12, y:1}},
    ];
    public static final MUTE:Array<ADrawableIconCommand> = [
        {t:MOVE, a:{x:7, y:5}},
        {t:LINE, a:{x:7, y:14}},
        {t:LINE, a:{x:3, y:11}},
        {t:LINE, a:{x:3, y:8}},
        {t:LINE, a:{x:7, y:5}},
        {t:MOVE, a:{x:9, y:3}},
        {t:LINE, a:{x:11, y:4}},
        {t:LINE, a:{x:12, y:7}},
        {t:LINE, a:{x:12, y:11}},
        {t:LINE, a:{x:11, y:14}},
        {t:LINE, a:{x:9, y:16}},
        {t:LINE, a:{x:10, y:14}},
        {t:LINE, a:{x:11, y:11}},
        {t:LINE, a:{x:11, y:7}},
        {t:LINE, a:{x:10, y:4}},
        {t:LINE, a:{x:9, y:3}},
        {t:MOVE, a:{x:12, y:1}},
        {t:LINE, a:{x:14, y:2}},
        {t:LINE, a:{x:16, y:6}},
        {t:LINE, a:{x:16, y:12}},
        {t:LINE, a:{x:15, y:15}},
        {t:LINE, a:{x:12, y:17}},
        {t:LINE, a:{x:14, y:15}},
        {t:LINE, a:{x:15, y:12}},
        {t:LINE, a:{x:15, y:6}},
        {t:LINE, a:{x:13, y:2}},
        {t:LINE, a:{x:12, y:1}},
        {t:MOVE, a:{x:0, y:20}},
        {t:LINE, a:{x:1, y:20}},
        {t:LINE, a:{x:20, y:0}},
        {t:LINE, a:{x:19, y:0}},
        {t:LINE, a:{x:0, y:20}},
        {t:MOVE, a:{x:0, y:0}},
        {t:LINE, a:{x:1, y:0}},
        {t:LINE, a:{x:20, y:20}},
        {t:LINE, a:{x:19, y:20}},
        {t:LINE, a:{x:0, y:0}},
    ];

    public static final WIN_CLOSE:Array<ADrawableIconCommand> = [
        {t:MOVE, a:{x:3, y:3}},
        {t:LINE, a:{x:16, y:17}},
        {t:LINE, a:{x:17, y:17}},
        {t:LINE, a:{x:4, y:3}},
        {t:LINE, a:{x:3, y:3}},
        {t:MOVE, a:{x:17, y:3}},
        {t:LINE, a:{x:4, y:17}},
        {t:LINE, a:{x:3, y:17}},
        {t:LINE, a:{x:16, y:3}},
        {t:LINE, a:{x:17, y:3}},
    ];
    public static final WIN_MAX:Array<ADrawableIconCommand> = [
        {t:MOVE, a:{x:3, y:3}},
        {t:LINE, a:{x:3, y:3}},
        {t:LINE, a:{x:17, y:3}},
        {t:LINE, a:{x:17, y:17}},
        {t:LINE, a:{x:3, y:17}},
        {t:LINE, a:{x:3, y:3}},
    ];
    public static final WIN_MIN:Array<ADrawableIconCommand> = [
        {t:MOVE, a:{x:3, y:7}},
        {t:LINE, a:{x:3, y:7}},
        {t:LINE, a:{x:17, y:7}},
        {t:LINE, a:{x:17, y:14}},
        {t:LINE, a:{x:3, y:14}},
        {t:LINE, a:{x:3, y:7}},
    ];
}