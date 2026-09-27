package backend.ui;

class AButton extends ASprite {
    public var disabled(default, set):Bool = false;
    public function set_disabled(a:Bool):Bool {
        disabled=a;
        if(disabled==true){
            removeEventListener(MouseEvent.CLICK, onMouseClick);
            removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
            setGraphicColor(AColor.BUTTON_DISABLED);
        }else{
            setGraphicColor(AColor.BUTTON_IDLE);
            if(!hasEventListener("click")) addEventListener(MouseEvent.CLICK, onMouseClick);
            if(!hasEventListener("mouseOver")) addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
            if(!hasEventListener("mouseOut")) addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
        }
        return disabled;
    }
    public var onC:AButton->Void;
    public var hasSymbol:Bool=false;
    public var targetSymbol:String= "";
    public var symbolParams:Array<Dynamic> = [];
    public function new(text:String, rect:Rectangle, onClick:AButton->Void) {
        super(rect.x, rect.y);
        onC=onClick;
        makeGraphic(Math.floor(rect.width), Math.floor(rect.height), AColor.BUTTON_IDLE); //TODO: get windows accent color

        if(text.trim().startsWith("[SYM:") && text.trim().endsWith(']')) {
            this.drawIcon(text.split(':')[1].replace("]", "").trim(), 1, AColor.BLACK, AColor.TRANSPARENT);

            hasSymbol = true;
            targetSymbol = text.split(':')[1].replace("]", "").trim();
            symbolParams = [1, AColor.BLACK, AColor.TRANSPARENT];
        }else{
            var label = new AText(0, 0, rect.width, text, 12);
            label.height = rect.height;
            label.alignment = CENTER;
            addChild(label);
        }

        addEventListener(MouseEvent.CLICK, onMouseClick);
        addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
        addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
    }
    public function onMouseClick(e:MouseEvent){
        setGraphicColor(AColor.BUTTON_CLICK);
        if(hasSymbol){
            this.drawIcon(targetSymbol, symbolParams[0], symbolParams[1], symbolParams[2]);
        }
        if(onC!=null) onC(this);
    }

    public function onMouseOver(e:MouseEvent) {
        setGraphicColor(AColor.BUTTON_HOVER);

        if(hasSymbol){
            this.drawIcon(targetSymbol, symbolParams[0], symbolParams[1], symbolParams[2]);
        }
    }

    public function changeSymbol(a:String) {
        if(!hasSymbol) return; //cancel.
        targetSymbol = a;
        this.drawIcon(targetSymbol, symbolParams[0], symbolParams[1], symbolParams[2]); //then redraw the icon.
    }

    public function onMouseOut(e:MouseEvent) {
        setGraphicColor(AColor.BUTTON_IDLE);
        if(hasSymbol){
            this.drawIcon(targetSymbol, symbolParams[0], symbolParams[1], symbolParams[2]);
        }
    }

    override public function destroy() {
        removeEventListener(MouseEvent.CLICK, onMouseClick);
        removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
        removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
        super.destroy();
    }
}