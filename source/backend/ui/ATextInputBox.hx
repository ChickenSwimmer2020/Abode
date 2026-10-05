package backend.ui;

//TODO: fix the bugs and make it work properly. cuz its being stupid
class ATextInputBox extends AText {
    public var onSubmit:String->Void;
    private var placeholderText:AText;
    public static var selectedTextBox:Null<ATextInputBox> = null;
    public function new(x:Float, y:Float, height:Float, width:Float, ?text:String, placeholder:String, fontSize:Int, oS:String->Void) {
        super(x, y, width, text ?? "", fontSize);

        makeGraphic(width.floor(), height.floor(), AColor.MAGENTA);
        placeholderText = new AText(0, 0, width, placeholder, fontSize);
        placeholderText.mouseEnabled = false; // let clicks fall through to the box
        addChild(placeholderText);

        onSubmit = oS;
        selectable = false; // we handle input ourselves, no native focus needed
        addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
        addEventListener(Event.ADDED_TO_STAGE, onAdded);
        setFieldSize(width, height);
    }

    function onAdded(_:Event) {
        stage.addEventListener(KeyboardEvent.KEY_DOWN, onkeyPressed);
        stage.addEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
    }

    override public function destroy() {
        stage.removeEventListener(KeyboardEvent.KEY_DOWN, onkeyPressed);
        stage.removeEventListener(MouseEvent.MOUSE_DOWN, onStageMouseDown);
        if (selectedTextBox == this) selectedTextBox = null;
        super.destroy();
    }
    function onMouseDown(_:MouseEvent) selectedTextBox = this;

    function onStageMouseDown(e:MouseEvent) {
        if (e.target == this || (Std.isOfType(e.target, DisplayObject) && contains(cast e.target))) return;
        selectedTextBox = null;
    }

    public function onkeyPressed(event:KeyboardEvent) {
        if (selectedTextBox != this) return;
        switch (event.keyCode) {
            case Keyboard.ENTER: event.shiftKey?text=text+="\n":{onSubmit(text); selectedTextBox=null;};
            case Keyboard.ESCAPE: selectedTextBox = null;
            case Keyboard.BACKSPACE: text = text.substr(0, text.length - 1);
            default: text += String.fromCharCode(event.charCode);
        }
        placeholderText.visible = (text == "");
    }
}