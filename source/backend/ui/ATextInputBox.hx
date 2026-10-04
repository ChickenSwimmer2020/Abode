package backend.ui;

//TODO: make functional.
class ATextInputBox extends AText {
    public var onSubmit:String->Void;
    private var placeholderText:AText;
    public static var selectedTextBox:Null<ATextInputBox> = null;
    public function new(x:Float, y:Float, height:Float, width:Float, ?text:String, placeholder:String, fontSize:Int, oS:String->Void) {
        super(x,y,width,text??"",fontSize);

        makeGraphic(width.floor(), height.floor(), AColor.MAGENTA); //TODO: proper coloring.
        placeholderText = new AText(0, 0, width, placeholder, fontSize);
        addChild(placeholderText);


        onSubmit = oS;
        addEventListener(KeyboardEvent.KEY_DOWN, onkeyPressed);
        addEventListener(MouseEvent.CLICK, onMouseClick);
    }
    public function onMouseClick(a:MouseEvent){
        if(selectedTextBox==null && selectedTextBox!=this) selectedTextBox = this;
    }

    public function onkeyPressed(event:KeyboardEvent) {
        if(selectedTextBox!=this) return;
        switch(event.keyCode) {
            default: text+=String.fromCharCode(event.charCode);
            case Keyboard.ENTER: event.shiftKey?text+="\n":onSubmit(text);
            case Keyboard.SHIFT, Keyboard.ALTERNATE, Keyboard.CONTROL: //donothing for now.

            case Keyboard.BACKSPACE: text = text.substr(0, text.length-1); //stupid way to do it, but it *should* work.
        }
    }
}