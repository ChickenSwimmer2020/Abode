package backend.ui;

enum AMenuBarAlignment {
    TOP;
    BOTTOM;
    LEFT;
    RIGHT;
}
enum AMenuBarObjectType {
    ATEXT;
    ASPRITE;
    ABUTTON;
    ACHECKBOX;
    //todo: support more if needbe
}
typedef AMenuBarObjectIdentifier = {
    var type:AMenuBarObjectType;
    @:optional var text:String;
    @:optional var size:APoint;
    @:optional var enabled:Bool;
    @:optional var color:AColor;
    @:optional var onClick:(Dynamic)->Void;
};

class AMenuBar extends ASprite {
    public var members:Array<ASprite> = [];
    public static final TBHeight:Int = 20;

    public var backing:ASprite;
    public var objects:Array<{key:String, object:ASprite}>=[];
    public var align(default, set):AMenuBarAlignment = TOP;
    public function set_align(a:AMenuBarAlignment):AMenuBarAlignment {
        align = a;
        return align;
    }
    public function new(align:AMenuBarAlignment, butts:Array<AMenuBarObjectIdentifier>) {
        super(0, 0);
        this.align = align;
        var targetPos:APoint = new APoint(0, 0);
        var targetSize:APoint = new APoint(Lib.application.window.width, TBHeight);
        switch(align){
            case LEFT:
                targetPos.set(0, 0); //position doesnt change, but the dimensions will
                targetSize.set(TBHeight, Lib.application.window.height);

            case RIGHT:
                targetPos.set(Lib.application.window.width-TBHeight, 0);
                targetSize.set(TBHeight, Lib.application.window.height);

            case BOTTOM:
                targetPos.set(0, Lib.application.window.height-TBHeight);
                targetSize.set(Lib.application.window.width, TBHeight);

            default:
                targetPos.set(0, 0);
                targetSize.set(Lib.application.window.width, TBHeight);
        }
        backing = new ASprite(targetPos.x, targetPos.y).makeGraphic(Math.floor(targetSize.x), Math.floor(targetSize.y), AColor.MENUBAR_BACKGROUND);
        add(backing);

        var offset:Float = 0;
        for(i=>possibleButton in butts){
            switch(possibleButton.type) {
                case ABUTTON: 
                    var newButton:AButton = new AButton(possibleButton.text, new Rectangle(0+offset, targetPos.y, possibleButton.size.x, possibleButton.size.y), possibleButton.onClick);
                    objects.push({key: possibleButton.text, object: newButton});
                    add(newButton);
                    offset += newButton.width+5;
                case ATEXT:
                    var newText:AText = new AText(0+offset, targetPos.y, possibleButton.size.x, possibleButton.text, 12);
                    objects.push({key: possibleButton.text, object: newText});
                    add(newText);
                    offset += newText.width+5;
                case ASPRITE:
                    var newSprite:ASprite = new ASprite(0+offset, targetPos.y).makeGraphic(possibleButton.size.iX, possibleButton.size.iY, possibleButton.color);
                    objects.push({key: possibleButton.text, object: newSprite});
                    add(newSprite);
                    offset += newSprite.width+5;
                case ACHECKBOX:
                    var newCheckbox:ACheckBox = new ACheckBox(0+offset, targetPos.y, possibleButton.text, possibleButton.onClick);
                    objects.push({key: possibleButton.text, object: newCheckbox});
                    add(newCheckbox);
                    if(possibleButton.enabled) newCheckbox.value = possibleButton.enabled;
                    offset += newCheckbox.width+5;
                default:
                    trace('Unknown AMenuBar object type "${possibleButton.type}".');
                    continue; //skip over the invalid one.
            }
        }
    }

    private inline function add(a:ASprite):ASprite {
        members.push(a);
        addChild(a);
        return a;
    }
    private inline function remove(a:ASprite):Bool {
        members.remove(a);
        cast(a, ASprite).destroy(); //auto calls `removeChild` from it.
        return a==null;
    }
}