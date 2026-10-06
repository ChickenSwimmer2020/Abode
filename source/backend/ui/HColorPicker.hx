package backend.ui;

class HColorPicker extends HSprite {
	var previewColor:HSprite;
	var colorPickerButton:HButton;
	var input:HTextInputBox;

	public function new(x:Float, y:Float, width:Float, height:Float, defaultColor:HColor, onChange:HColor->Void) {
		super(x, y);

		previewColor = new HSprite(0, 0).makeGraphic(width.floor(), height.floor(), defaultColor);
		addChild(previewColor);

		colorPickerButton = new HButton("...", new Rectangle(0, 0, height.floor(), height.floor()), (_:HButton) -> {
			trace("TODO: Color picker");
		});
		addChild(colorPickerButton);

		input = new HTextInputBox(height, 0, height, width - height, null, '${defaultColor.toHexString()}', 12, (_:String) -> {
			trace('TODO: on change try to redo the color');
		});
		addChild(input);
	}
}
