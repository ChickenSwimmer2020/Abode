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
    public var onC:Void->Void;
    public function new(text:String, rect:Rectangle, onClick:Void->Void) {
        super(rect.x, rect.y);
        onC=onClick;
        makeGraphic(Math.floor(rect.width), Math.floor(rect.height), AColor.BUTTON_IDLE); //TODO: get windows accent color

        var label = new AText(0, 0, rect.width, text, 12);
        label.height = rect.height;
        label.alignment = CENTER;
        addChild(label);

        addEventListener(MouseEvent.CLICK, onMouseClick);
        addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
        addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
    }
    public function onMouseClick(e:MouseEvent){
        setGraphicColor(AColor.BUTTON_CLICK);
        if(onC!=null) onC();
    }

    public function onMouseOver(e:MouseEvent) {
        setGraphicColor(AColor.BUTTON_HOVER);
    }

    public function onMouseOut(e:MouseEvent) {
        setGraphicColor(AColor.BUTTON_IDLE);
    }

    override public function destroy() {
        removeEventListener(MouseEvent.CLICK, onMouseClick);
        removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
        removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
        super.destroy();
    }
}