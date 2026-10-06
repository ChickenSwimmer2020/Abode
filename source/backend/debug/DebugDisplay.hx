package backend.debug;

#if debug
class DebugDisplay extends Sprite {
	private var label:AText;
	private var frameCount:Int = 0;
	private var fps:Float = 0;
	private var fpsTimer:Float = 0;
	private var lastTime:Int = 0;

	public function new() {
		super();

		// background
		graphics.beginFill(AColor.DEBUGGER_BACKGROUND.rgb, AColor.DEBUGGER_BACKGROUND.a);
		graphics.drawRect(0, 0, 200, 80);
		graphics.endFill();

		// text field
		label = new AText(0, 0, 200, "", 11);
		label.defaultTextFormat = new TextFormat("_typewriter", 11, AColor.DEBUGGER_CONSOLE_TEXT);
		label.setFieldSize(-1, 80);
		addChild(label);

		lastTime = openfl.Lib.getTimer();
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	static var MSGS:Array<Dynamic> = [];
	static var lastMsgs:Array<Dynamic> = ["this is so it actually changes the first time."];

	var finalMsg:String = "";

	private function onEnterFrame(e:Event):Void {
		var now = openfl.Lib.getTimer();
		var dt = (now - lastTime) / 1000.0;
		lastTime = now;

		frameCount++;
		fpsTimer += dt;

		if (fpsTimer >= 0.5) { // update every 0.5 seconds
			fps = frameCount / fpsTimer;
			frameCount = 0;
			fpsTimer = 0;
		}

		var mem = System.totalMemory / 1024 / 1024; // bytes to MB

		// if(MSGS!=){ //TODO: optimize and make it only update if it needs to.
		MSGS = ([
			{key: "FPS", value: Math.round(fps)},
			{key: "STA", value: Main.StateSystem.currentState},
			{key: "MEM||MB", value: (Math.round(mem * 10) / 10)},
			{key: "STG||children", value: ((stage != null) ? stage.numChildren : 0)},
			{key: "OBJ||children", value: numChildren},
			{key: "CST", value: ATextInputBox.selectedTextBox},
			{key: "DDO", value: ADropdown.dropdownOpen},
			{key: "SSD", value: ADropdown.subDropdownOpen},
		] : Array<Dynamic>);
		// }

		if (finalMsg != "")
			finalMsg = "";
		for (label in MSGS)
			finalMsg += '${label.key.split('||')[0]}:    ${label.value} ${label.key.split('||')[1] ?? ""}\n';
		if (label.height != (0 + (20 * (MSGS.length - 1)))) { // only update the graphics if we need too.
			label.setFieldSize(-1, 0 + (20 * (MSGS.length - 1)));
			graphics.clear();
			graphics.beginFill(AColor.DEBUGGER_BACKGROUND.rgb, AColor.DEBUGGER_BACKGROUND.a);
			graphics.drawRect(0, 0, 200, label.height);
			graphics.endFill();
		}
		label.text = finalMsg;
		lastMsgs = MSGS;
	}

	public function destroy():Void {
		removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		if (parent != null)
			parent.removeChild(this);
	}
}
#end
