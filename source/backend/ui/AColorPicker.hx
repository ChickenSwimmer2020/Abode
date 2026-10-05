package backend.ui;

class AColorPicker extends ASprite {
    var previewColor:ASprite;
    var colorPickerButton:AButton;
    var input:ATextInputBox;
    public function new(x:Float, y:Float, width:Float, height:Float, defaultColor:AColor, onChange:AColor->Void){
        super(x, y);

        previewColor = new ASprite(0, 0).makeGraphic(width.floor(), height.floor(), defaultColor);
        addChild(previewColor);

        colorPickerButton = new AButton("...", new Rectangle(0, 0, height.floor(), height.floor()), (_:AButton)->{
            trace("TODO: Color picker");
        });
        addChild(colorPickerButton);

        input = new ATextInputBox(height, 0, height, width-height, null, '${defaultColor.toHexString()}', 12, (_:String)->{
            trace('TODO: on change try to redo the color');
        });
        addChild(input);
    }
}