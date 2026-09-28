package backend.ui;

class ProjectBox extends ASprite {
    public static final SIZE:APoint = new APoint(300, 75);

    public var icon:ASprite;
    public var title:AText;
    public var lastUsed:AText;
    public var size:AText;
    public var desc:AText;
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

        desc = new AText(0+SIZE.y, 0, width, "Description go brrrr", 12);
        desc.height = height;
        desc.y = SIZE.y-(desc.textHeight+5);
        addChild(desc);
    }

    public function loadData(name:String, type:String, lastModded:String, ?description:String) {
        title.text = '$name.${type=="Flash"?"Fla":"APF"}';
        if(type=="Flash"){
            title.textColor = 0xFFFFFFFF;
            lastUsed.textColor = 0xFFFFFFFF; 
        } 
        lastUsed.text = lastModded;
        desc.text = description??"";//show nothing if its null.

        makeGraphic(gWidth, gHeight, type=="Flash"?0xFF1b1b1b:0xFF5a5a5a); //FF1b1b1b is fron animate directly, thanks Windows+shift+c!
        switch(type) { //graphic, *then* icon.
            case "Flash": DrawUtil.drawIcon(this, "FILE_FLASH", 1, 0xFF9999FF, 0xFF00005B);
            case "AbodeProjectFormat": DrawUtil.drawIcon(this, "FILE_ABODEPROJECTFORMAT", 1, 0xFF9173B5, 0xFF89B2B7);
        }
    }
}