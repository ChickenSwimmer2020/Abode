package backend.ui;

import backend.utils.AColor;
import openfl.text.TextFormatAlign;
import openfl.events.MouseEvent;

class AButton extends ASprite {
    public var onC:Void->Void;
    public function new(text:String, rect:Rectangle, onClick:Void->Void) {
        super(rect.x, rect.y);
        onC=onClick;
        makeGraphic(Math.floor(rect.width), Math.floor(rect.height), 0xFFFFFF, 1.0); //TODO: get windows accent color

        var label = new TextField();
        label.width = rect.width;
        label.height = rect.height;
        label.selectable = false;
        label.mouseEnabled = false;
        label.text = text;
        var format = new TextFormat();
        format.align = TextFormatAlign.CENTER;
        label.setTextFormat(format); 
        addChild(label);

        addEventListener(MouseEvent.CLICK, onMouseClick);
        addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
        addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
    }
    public function onMouseClick(e:MouseEvent){
        color = AColor.BUTTON_CLICK;
        if(onC!=null) onC();
    }

    public function onMouseOver(e:MouseEvent) {
        color = AColor.BUTTON_HOVER;
    }

    public function onMouseOut(e:MouseEvent) {
        color = AColor.BUTTON_IDLE;
    }

    override public function destroy() {
        removeEventListener(MouseEvent.CLICK, onMouseClick);
        removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
        removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
        super.destroy();
    }
}