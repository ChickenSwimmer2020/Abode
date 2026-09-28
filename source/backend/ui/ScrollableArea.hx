package backend.ui;

import backend.utils.AMath;
import backend.objects.AGroup;

class ScrollableArea extends AGroup<ASprite> {
    public var index:Int = 0;
    public var target:Float = 0.0;
    public function new(x:Float, y:Float) {
        super(x, y);
        addEventListener(MouseEvent.MOUSE_WHEEL, onMouseScroll);
        addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

    public function onEnterFrame(e:Event){
        target = AMath.lerp(target, index, 0.1);
        scrollRect = new Rectangle(0, 0+target, width, height);
    }

    public function onMouseScroll(e:MouseEvent) {
        if(containsMouse()){
            index+=(#if(html5)e.delta #else e.delta*40#end); //delta is fucky on html.
            if(index<0) index=0;
        }
    }

    override public function destroy() {
        removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseScroll);
        super.destroy();
    }
}