package backend.ui;

import lime.utils.AssetLibrary;

enum AMenuBarAlignment {
    TOP;
    BOTTOM;
    LEFT;
    RIGHT;
}

typedef AButtonIdentifier = {
    var text:String;
    var size:APoint;
    var onClick:Void->Void;
} 

class AMenuBar extends ASprite {
    public static final TBHeight:Int = 20;
    public static var dropdownOpen:Bool = false;
    public static var instance:Null<AMenuBar> = null;
    public static var canCloseInstace:Bool=false;

    public var backing:ASprite;
    public var buttons:Array<AButton>=[];
    public function new(align:AMenuBarAlignment, butts:Array<AButtonIdentifier>) {
        super(0, 0);

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
                targetPos.set(Lib.application.window.height-TBHeight, 0);
                targetSize.set(Lib.application.window.width, TBHeight);

            default:
                targetPos.set(0, 0);
                targetSize.set(Lib.application.window.width, TBHeight);
        }
        backing = new ASprite(targetPos.x, targetPos.y).makeGraphic(Math.floor(targetSize.x), Math.floor(targetSize.y), 0x7B7B7B, 1.0);
        addChild(backing);

        var index:Int = 0;
        for(possibleButton in butts){
            if(possibleButton.onClick!=null && possibleButton.size!=null) {
                var newButton:AButton = new AButton(possibleButton.text, new Rectangle(0+(possibleButton.size.x*index)+(5*index), 0, possibleButton.size.x, possibleButton.size.y), possibleButton.onClick);
                buttons.push(newButton);
                addChild(newButton);
                index++;
            }else{
                trace('Malformed button data $possibleButton.');
                continue;
            }
        }
    }

    var dropdownBG:ASprite;
    var dropdownButtons:Array<OneOfTwo<ASprite, AButton>> = [];
    var increment:Float = 0.0;
    public function openDropdownMenu(index:Int, options:Array<{text:String, func:Void->Void}>, ?overWidth:Int) {
        if(dropdownOpen) return;
        var targetPosition:APoint = new APoint(buttons[index].x, buttons[index].y+TBHeight);
        trace('Opening a dropdown menu at ${targetPosition.toString()} with options $options');

        dropdownBG = new ASprite(targetPosition.x, targetPosition.y).makeGraphic(Math.floor(overWidth??buttons[index].width), Math.floor(buttons[index].height*Lambda.count(options)), 0x262626, 1.0);
        addChild(dropdownBG);
        var ind:Int = 0;
        increment = 0.0;
        for(t in options) {
            var text = t.text;

            if(text == 'seperator') {
                var seperator:ASprite = new ASprite(targetPosition.x, targetPosition.y+(buttons[index].height*ind));
                seperator.makeGraphic(Math.floor(overWidth!=null?(overWidth/2):(buttons[index].width/2)), Math.floor(buttons[index].height/4), 0x000000, 1.0);
                dropdownButtons.push(seperator);
                addChild(seperator);
                increment += seperator.height;
            }else{
                var func = t.func;
                var button:AButton = new AButton(text, new Rectangle(targetPosition.x, targetPosition.y+increment, overWidth??buttons[index].width, buttons[index].height), func);
                dropdownButtons.push(button);
                addChild(button);
                increment += button.height;
            }
            ind++;
        }

        instance = this;
        dropdownOpen = true;
        ATimer.start(0.02, ()->{
            canCloseInstace = true;
        });
    }
    public function closeDropdownMenu() {
        trace("Destroying the instance of ADropdownMenu");
        for(button in dropdownButtons){ //stupid casting requirements.
            if(button is ASprite) (button:ASprite)?.destroy();
            if(button is AButton) (button:AButton)?.destroy();
        }
        dropdownBG.destroy();
        instance = null;
        dropdownOpen = false;
        canCloseInstace=false;
    }
}