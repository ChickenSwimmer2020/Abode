package backend.ui;

class ScrollableArea extends ASprite {
    public var members:Array<ASprite> = [];
    public function new(x:Float, y:Float) {
        super(x, y);
    }

    public function add(a:ASprite):ASprite {
        addChild(a);
        members.push(a);
        return a;
    }
}