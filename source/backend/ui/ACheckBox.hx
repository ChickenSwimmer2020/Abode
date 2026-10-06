package backend.ui;

// TODO: fix the graphics on this because they're being fucky.
class ACheckBox extends ASprite {
	public var label:AText;
	public var value(default, set):Bool = false;

	public function set_value(a:Bool):Bool {
		value = a;
		onBoxClick(null, false);
		return value;
	}

	public var onClick:Null<(Bool) -> Void> = null; // for if you wanna do something on click.

	private final _SIZE:Int = 20;
	private final _oSIZE:Int = 2;
	private var box:ASprite; // for holding the actual checkbox and such.

	public function new(x:Float, y:Float, text:String, ?oC:(Bool) -> Void) {
		super(x, y);
		if (oC != null)
			onClick = oC;
		box = new ASprite(0, 0).makeGraphic(_SIZE, _SIZE, AColor.BLACK);
		box.addEventListener(MouseEvent.CLICK, (_:MouseEvent) -> {
			onBoxClick(_, true);
		}); // so we can detect clicks and such

		label = new AText(0 + _SIZE + 5, 0, 100, text, 12);

		addChild(box);
		addChild(label);
		reRender();
	}

	function onBoxClick(_:MouseEvent, ?set:Bool = true) {
		if (set)
			value = !value;
		if (onClick != null)
			onClick(value); // yay return.
		reRender();
	}

	override function reRender():ASprite {
		super.reRender();
		box.addRect(new Rectangle(_oSIZE, _oSIZE, _SIZE - (_oSIZE * 2), _SIZE - (_oSIZE * 2)), AColor.WHITE); // then the icon
		if (value)
			box.drawIcon("UICHECK", 1, AColor.MAGENTA, AColor.TRANSPARENT);
		return this;
	}

	override public function destroy() {
		box.removeEventListener(MouseEvent.CLICK, (_:MouseEvent) -> {
			onBoxClick(_, true);
		});
		super.destroy(); // destroys everyting properly, remove event listeners first!
	}
}
