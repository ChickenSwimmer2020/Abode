package;

class Main extends Sprite {
	/**
	 * The desktop background, stored as a BitmapData directly within Main so that we only have to load it once.
	 * @since 0.00.004
	 */
	public static #if (sys && !mac) final #else var #end desktopbackgroundImage:BitmapData #if (sys && !mac) = HSprite.getDesktopWallpaper(1280, 720) #end;

	/**
	 * For checking when global keys are pressed.
	 * @since 0.00.004
	 */
	private static var onKeyPressed:Map<String, {k:String, ar:Bool, c:KeyboardEvent->Void}>;

	/**
	 * Add an listener to `onKeyPressed` globally, functions are set when this function is called.
	 * @param a the name of the listener
	 * @param k the key to listen to (set to "*" for any key)
	 * @param autoRemove should the listener remove automatically?
	 * @param c the function to run
	 * @since 0.00.004
	 */
	public static function addKeyPressed(a:String, k:Dynamic, autoRemove:Bool = true, c:KeyboardEvent->Void) {
		try {
			if (onKeyPressed == null)
				onKeyPressed = new Map<String, {k:String, ar:Bool, c:KeyboardEvent->Void}>();
			if (onKeyPressed.get(a) != null)
				return; // cuz it already exists, so why add it again?
			onKeyPressed.set(a, {k: Std.string(k), ar: autoRemove, c: c});
			trace('added "$a" to keyboard listener.');
		} catch (e:Exception)
			traceError(e);
	}

	/**
	 * Remove a listener from the event pool, only realled used when autoRemove is true
	 * @param a target listener
	 * @return Bool if the listener was removed correctly
	 * @since 0.00.004
	 */
	public static function removeKeyPressed(a:String):Bool {
		try {
			onKeyPressed.remove(a);
			trace('removed "$a" from keyboard listener.');
			return (onKeyPressed.get(a) == null);
		} catch (e:Exception)
			traceError(e);
		return false;
	}

	/**
	 * Instance access to Main
	 * @since 0.00.002
	 */
	public static var instance:Main;

	/**
	 * Program internal width
	 * @since 0.00.001
	 */
	public static var pWidth:Int = 1280;

	/**
	 * Program internal height
	 * @since 0.00.001
	 */
	public static var pHeight:Int = 720;

	/**
	 * the current mouse position, relative to the resized/scaled stage
	 * @since 0.00.002
	 */
	public static var vMouse:HPoint = new HPoint(0, 0);

	/**
	 * for managing the in-windows windows of HYDRO-FRAME
	 * @since 0.00.002
	 */
	public static var windowManager:HWindowManager;

	#if debug
	/**
	 * DEBUG EXCLUSIVE
	 * Debugger stats, inclueds fps, memory, and loaded objects.
	 * @since pre-0.00.001
	 */
	public var stats:DebugDisplay;
	#end

	/**
	 * State system, controls the actual states of HYDRO-FRAME, this is actually a very important thing.
	 * @since pre-0.00.001
	 */
	public static var StateSystem:StateSystemInit = new StateSystemInit(null); // defaults to splashscreen since thats literally the only thing it does on init

	/**
	 * Entry point of HYDRO-FRAME for launching, this is what does stuff before any state loads.
	 */
	public function new() {
		super();
		try {
			#if (html5 || mac)
			desktopbackgroundImage = HSprite.getDesktopWallpaper(1280, 720); // fix for a crash on startup with html5.
			if ((UPrefs.prefsData.data.preferencesCreated : Bool) == null) { // to actually create preferences.
				UPrefs.makePrefsFile();
				UPrefs.prefsData.data.preferencesCreated = true;
				UPrefs.prefsData.flush();
			}
			#end
			Native.flashTaskbar();
			Log.throwErrors = false; // STOP CRASHING MAH GAME!
			instance = this;
			#if (hl && !debug) hl.UI.closeConsole(); #end
			stage.scaleMode = #if html5 StageScaleMode.EXACT_FIT; #else StageScaleMode.NO_SCALE; #end
			stage.align = StageAlign.TOP_LEFT;
			Lib.application.window.onClose.add(onClosing);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
			stage.addEventListener(Event.RESIZE, onStageResize);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(MouseEvent.CLICK, onMouseClick);
			onStageResize(null); // apply once at startup
			Application.current.window.title = '${Application.current.window.title}: [${Application.current.meta.get("version")}]';

			HTween.globalParent = this; // so that new Tween() will auto-destroy and not cause memory leaks.
			windowManager = new HWindowManager();

			addChild(StateSystem);
			StateSystem.switchState(SplashScreen); // wait fuck this might work!

			#if debug
			stats = new DebugDisplay();
			stage.addChild(stats); // add to stage directly so it's always on top
			stats.x = 10;
			stats.y = 10;
			stats.visible = UPrefs.debuggerVisible.value;
			#end

			Mouse.hide();
		} catch (e:Exception)
			traceError(e);
	}

	/**
	 * Used with the listener system for checking when a key is pressed and doing an associated action
	 * @param e 
	 * @since 0.00.001
	 */
	private function onKeyDown(e:KeyboardEvent) {
		try {
			#if (debug) // whoops.
			if (e.keyCode == Keyboard.F1) {
				stats.visible = !stats.visible;
				UPrefs.debuggerVisible.value = stats.visible;
			}
			#end

			if (onKeyPressed != null) {
				for (label => info in onKeyPressed) {
					if (label == null || info == null)
						continue;
					if (info.k == "*") {
						if (info.c != null) {
							info.c(e);
							info.ar ? removeKeyPressed(label) : null;
						} else {
							trace('Null info found with $label!!');
						}
					} else {
						var tk:Null<Int> = Std.parseInt(info.k);
						if (tk == null) {
							trace('Couldnt parse ${info.k} on $label, so we\'re skipping it.');
							continue;
						}
						if (e.keyCode == tk) {
							if (info.c != null) {
								info.c(e);
								info.ar ? removeKeyPressed(label) : null;
							} else {
								trace('Null info found with $label!!');
							}
						} else
							continue;
					}
				}
			}

			if (HDropdown.dropdownOpen) { // TODO: fix this.
				for (keys => targetOption in HDropdown.dropdownKeys) {
					if (!keys.contains(e.keyCode) && (!e.shiftKey && (!e.altKey && !e.controlKey))) {
						if (HDropdown.canCloseInstace)
							HDropdown.closeDropdownMenu(); // force close any open instance.
					} else {
						var targetKeys:Array<Bool> = [];
						var allKeys:Array<Int> = keys;
						for (key in allKeys) {
							if (key == Keyboard.CONTROL) {
								targetKeys.push(e.controlKey);
								allKeys.splice(allKeys.indexOf(17), 1);
								continue;
							}
							if (key == Keyboard.ALTERNATE) {
								targetKeys.push(e.altKey);
								allKeys.splice(allKeys.indexOf(18), 1);
								continue;
							}
							if (key == Keyboard.SHIFT) {
								targetKeys.push(e.shiftKey);
								allKeys.splice(allKeys.indexOf(16), 1); // remove the key from the array
								continue; // then skip over the index
							}
							// targetKeys.push((e.keyCode == e.));
							allKeys.splice(allKeys.indexOf(e.keyCode), 1); // remove the key from the array
						}

						trace(targetKeys);

						// if(targetKeys.allTrue())
						// HMenuBar.instance.buttons.get(targetOption).onC();
					}
				}
			}
		} catch (e:Exception)
			traceError(e);
	}

	/**
	 * Used mostly for closing dropdowns when needed, might be expanded in the future.
	 * @param e mouseEvent, this is called by underlying Lime layers 
	 * @since 0.00.001
	 */
	private function onMouseClick(e:MouseEvent) {
		try {
			if (HDropdown.subDropdownOpen && HDropdown.canCloseSubInstace) {
				if (!HDropdown.subDropdownBG.containsMouse()) { // if off the backing, then exit.
					HDropdown.closeSubDropdownMenu(); // force close any open instance.
				} else {
					for (object in HDropdown.members) {
						if (object == HDropdown.subDropdownBG)
							continue; // skip it and dont increase index
						var obj:HSprite = cast(object, HSprite);
						if (obj.containsMouse()) {
							if (cast(obj.getAttribute("closeFullDropdown"), Bool) == true) {
								HDropdown.closeSubDropdownMenu();
								HDropdown.closeDropdownMenu(); // cuz, close the whole thing.
							}
							if (cast(obj.getAttribute("isSubDropdownObject"), Bool) == true) {
								if (cast(obj.getAttribute("closeOnClick"), Bool) == true) {
									HDropdown.closeSubDropdownMenu();
								} else {
									continue;
								}
							} else {
								continue;
							}
						}
					}
				}
			} else if (HDropdown.dropdownOpen && HDropdown.canCloseInstace) {
				if (!HDropdown.dropdownBG.containsMouse()) { // if off the backing, then exit.
					HDropdown.closeDropdownMenu(); // force close any open instance.
				} else {
					for (object in HDropdown.members) {
						if (object == HDropdown.dropdownBG)
							continue; // skip it and dont increase index
						var obj:HSprite = cast(object, HSprite);
						if (obj.containsMouse()) {
							if (cast(obj.getAttribute("isDropdownObject"), Bool) == true) {
								if (cast(obj.getAttribute("closeOnClick"), Bool) == true) {
									HDropdown.closeDropdownMenu();
								} else {
									continue;
								}
							} else {
								continue;
							}
						}
					}
				}
			}
		} catch (e:Exception)
			traceError(e);
	}

	/**
	 * OPENFL's actual scale mode for Stage is ASS AF. so we're gonna do it properly.
	 * 
	 * Resizes the window, but also the stage properly, its based on the way that flixel sizes FlxGame.
	 * @param _ Event, called by underlying Lime Layers
	 * @since 0.00.001
	 */
	private function onStageResize(_:Event):Void {
		try {
			#if sys
			var w = stage.stageWidth;
			var h = stage.stageHeight;
			var s = Math.min(w / pWidth, h / pHeight);

			scaleX = scaleY = s;
			x = (w - pWidth * s) / 2;
			y = (h - pHeight * s) / 2;
			#elseif html5
			pWidth = Application.current.window.width;
			pHeight = Application.current.window.height;
			#end
			updateVirtualMouse();
		} catch (e:Exception)
			traceError(e);
	}

	/**
	 * Called whenever the mouse moves, only used to update the `vMouse` variable.
	 * @param _ MouseEvent
	 * @since 0.00.001
	 */
	private inline function onStageMouseMove(_:MouseEvent):Void
		try {
			updateVirtualMouse();
		} catch (e:Exception)
			traceError(e);

	/**
	 * Actually updates the `vMouse` variable.
	 */
	private inline function updateVirtualMouse():Void
		try {
			vMouse.set(((stage.mouseX - x) / scaleX), ((stage.mouseY - y) / scaleY));
		} catch (e:Exception)
			traceError(e);

	/**
	 * Adds to the main stage, so it adds above everything, including the state
	 * @param a DisplayObject to add
	 * @since 0.00.001
	 */
	public function addToMainStage(a:DisplayObject)
		try {
			addChild(a);
		} catch (e:Exception)
			traceError(e);

	/**
	 * remove from the main stage
	 * @param a DisplayObject to add
	 * @since 0.00.001
	 */
	public function removeFromMainStage(a:DisplayObject)
		try {
			removeChild(a);
		} catch (e:Exception)
			traceError(e);

	/**
	 * Called when the window is closing, currently used for cleanup.
	 * @since 0.00.001
	 */
	public function onClosing() {
		try {
			#if debug
			stats.destroy();
			#end

			stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.removeEventListener(Event.RESIZE, onStageResize);
			Lib.application.window.onClose.remove(onClosing);
		} catch (e:Exception)
			traceError(e);
	}

	/**
	 * traces an error with pos information and errors
	 * @param e Exception, contains the file information
	 * @param _ PosInfos, dont add anything here, its done automatically.
	 * @since 0.00.004
	 */
	public static function traceError(e:Exception, ?_:PosInfos) {
		trace('AN ERROR OCCURED: ${e.message} FROM FILE ${_.fileName} LINE ${_.lineNumber}');
		trace('WITH STACK: ${e.stack.toString()}');
	}
}
