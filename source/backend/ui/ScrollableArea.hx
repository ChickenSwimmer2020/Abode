package backend.ui;

class ScrollableArea extends AGroup<ASprite> {
    public var interactable:Bool = true;
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
        if(interactable) {
            if(containsMouse()){
                final delta:Int = (#if(html5)e.delta #else e.delta*40#end);
                if(UPrefs.inverseScrollDirection.value) index+=delta; //delta is fucky on html.
                else index-=delta;
                if(index<0) index=0;
            }
        }
    }

    override public function destroy() {
        removeEventListener(MouseEvent.MOUSE_WHEEL, onMouseScroll);
        super.destroy();
    }
}