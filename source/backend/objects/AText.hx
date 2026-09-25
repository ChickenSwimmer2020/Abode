package backend.objects;

enum abstract ATextAlign(String) {
    var LEFT;
    var RIGHT;
    var CENTER;

    public static function toOpenflAlign(a:ATextAlign):TextFormatAlign {
        switch(a) {
            case LEFT: return TextFormatAlign.LEFT;
            case CENTER: return TextFormatAlign.CENTER;
            case RIGHT: return TextFormatAlign.RIGHT;
        }
        return TextFormatAlign.LEFT;
    }
}

class AText extends TextField {
    @:noCompletion private var format:TextFormat; //dumb way to do it but yeahh
    //stuffs
    public var alignment(default, set):ATextAlign = LEFT;
    public function set_alignment(a:ATextAlign):ATextAlign {
        alignment = a;
        format.align = ATextAlign.toOpenflAlign(a);
        setTextFormat(format);
        return a;
    }
    public var fontSize(default, set):Int = 12;
    public function set_fontSize(a:Int):Int {
        fontSize = a;
        format.size = a;
        setTextFormat(format);
        return a;
    }

    //funcs
    public function new(x:Float=0, y:Float=0, width:Float=0, text:String="", fontSize:Int=12) {
        super();
        if(format==null) format = new TextFormat();
        this.width = width;
        this.x = x; //whoops forgot about this.
        this.y = y;
        this.selectable = false;
        this.mouseEnabled = false;
        this.text = text; 
        this.fontSize = fontSize;
    }
}