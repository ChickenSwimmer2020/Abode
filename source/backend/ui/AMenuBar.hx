package backend.ui;

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
    public var members:Array<ASprite> = [];
    public static final TBHeight:Int = 20;
    public static var dropdownOpen:Bool = false;
    public static var instance:Null<AMenuBar> = null;
    public static var canCloseInstace:Bool=false;

    public var backing:ASprite;
    public var buttons:Array<{key:String, button:AButton}>=[];
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
        backing = new ASprite(targetPos.x, targetPos.y).makeGraphic(Math.floor(targetSize.x), Math.floor(targetSize.y), AColor.MENUBAR_BACKGROUND);
        add(backing);

        var index:Int = 0;
        for(possibleButton in butts){
            if(possibleButton.onClick!=null && possibleButton.size!=null) {
                var newButton:AButton = new AButton(possibleButton.text, new Rectangle(0+(possibleButton.size.x*index)+(5*index), 0, possibleButton.size.x, possibleButton.size.y), possibleButton.onClick);
                buttons.push({key: possibleButton.text, button: newButton});
                add(newButton);
                index++;
            }else{
                trace('Malformed button data $possibleButton.');
                continue;
            }
        }
    }

    public var dropdownBG:ASprite;
    var dropdownButtons:Array<OneOfTwo<ASprite, AButton>> = [];
    var increment:Float = 0.0;
    public var dropdownKeys:Map<Array<Int>, String>=[];
    public function openDropdownMenu(index:Int, options:Array<{text:String, ?closeOnClick:Bool, ?keys:Array<Int>, ?disabled:Bool, func:Void->Void}>, ?overWidth:Int) {
        if(dropdownOpen) return;
        var targetPosition:APoint = new APoint(buttons[index].button.x, buttons[index].button.y+TBHeight);

        dropdownBG = new ASprite(targetPosition.x, targetPosition.y).makeGraphic(Math.floor(overWidth??buttons[index].button.width), Math.floor(buttons[index].button.height*Lambda.count(options)), AColor.MENUBAR_DROPDOWN_BACKGROUND);
        add(dropdownBG);
        var ind:Int = 0;
        increment = 0.0;
        for(t in options) {
            var shouldCloseWhenClicked:Bool = t.closeOnClick??true;
            var disabled = t.disabled??false;
            var text = t.text;
            if(t.keys!=null) dropdownKeys.set(t.keys, text);

            if(text == 'seperator') {
                var seperator:ASprite = new ASprite(targetPosition.x, targetPosition.y+(buttons[index].button.height*ind));
                seperator.makeGraphic(Math.floor(overWidth!=null?(overWidth/2):(buttons[index].button.width/2)), Math.floor(buttons[index].button.height/4), AColor.MENUBAR_DROPDOWN_SEPERATOR);
                dropdownButtons.push(seperator);
                add(seperator);
                seperator.setAttribute("isDropdownObject", true);
                seperator.setAttribute("closeOnClick", false);
                increment += seperator.height;
            }else{
                var func = t.func;
                var button:AButton = new AButton(text, new Rectangle(targetPosition.x, targetPosition.y+increment, overWidth??buttons[index].button.width, buttons[index].button.height), func);
                dropdownButtons.push(button);
                add(button);
                button.setAttribute("isDropdownObject", true);
                button.setAttribute("closeOnClick", disabled?false:shouldCloseWhenClicked);
                button.disabled = disabled;
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
            if(button is ASprite) remove((button:ASprite));
            if(button is AButton) remove((button:AButton));
        }
        for(keys=>key in dropdownKeys) dropdownKeys.remove(keys);
        remove(dropdownBG);
        instance = null;
        dropdownOpen = false;
        canCloseInstace=false;
    }


    private inline function add(a:ASprite):ASprite {
        members.push(a);
        addChild(a);
        return a;
    }
    private inline function remove(a:ASprite):Bool {
        members.remove(a);
        a.destroy(); //auto calls `removeChild` from it.
        return a==null;
    }
}