package backend.ui;

class ProjectBox extends ASprite {
    public static final SIZE:APoint = new APoint(300, 75);

    public var icon:ASprite;
    public var title:AText;
    public var lastUsed:AText;
    public var size:AText;
    public var kind:AText;
    public function new(x:Float, y:Float) {
        super(x, y);

        makeGraphic(SIZE.iX, SIZE.iY, AColor.RED);
        this.addRect(new Rectangle(0, 0, SIZE.y, SIZE.y), AColor.MAGENTA); //debug fallback if the image cant load
        
        title = new AText(0+SIZE.y, 0, width, "[project].(apf/fla)", 12);
        title.height = height;
        addChild(title);

        size = new AText(0, 0, width, "---.--- (KB/MB/GB)", 12); //why will we support gb? idfk lmfao.
        size.height = height;
        size.x = SIZE.x-(size.textWidth+5);
        addChild(size);

        lastUsed = new AText(0+SIZE.y, 0+title.textHeight, width, "[yesterday, [last | week/month/year], ~ /days/weeks/months/years | ago]", 12);
        lastUsed.height = height-title.textHeight;
        addChild(lastUsed);

        kind = new AText(0+SIZE.y, 0, width, "(Abode/Animate) [symbol of program in custom font]", 12);
        kind.height = height;
        kind.y = SIZE.y-(kind.textHeight+5);
        addChild(kind);
    }
}