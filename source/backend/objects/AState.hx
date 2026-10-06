package backend.objects;

/**
 * AState, its a state. functions like FlxState from Flixel
 * @since 0.00.000
 */
class AState extends Sprite {
	/**
	 * members of the state
	 * @since 0.00.000
	 */
	public var members:Array<Dynamic> = [];

	/**
	 * UNFINISHED
	 * @since 0.00.004
	 */
	public var canInteract(default, set):Bool = true;

	/**
	 * UNFINISHED
	 * @since 0.00.004
	 */
	private var lastButtonStates:Map<AButton, Bool> = new Map<AButton, Bool>();

	/**
	 * UNFINISHED
	 * @param a UNFINISHED
	 * @since 0.00.004
	 */
	public function set_canInteract(a:Bool):Bool {
		canInteract = a;
		for (member in members) {
			if (member is AButton) {
				if (a) {
					(member : AButton).disabled = lastButtonStates.get((member : AButton));
					(member : AButton).doDisabledColor = false;
					lastButtonStates.remove((member : AButton));
				} else {
					lastButtonStates.set((member : AButton), (member : AButton).disabled);
					(member : AButton).doDisabledColor = false;
					(member : AButton).disabled = true;
				}
			}
		}
		return canInteract;
	}

	/**
	 * make a new state
	 * @since 0.00.000
	 */
	public function new() {
		super();
	}

	/**
	 * add a new object to the state
	 * @param basic basic to add
	 * @return Dynamic the basic that was added
	 * @since 0.00.000
	 */
	public function add(basic:Dynamic):Dynamic {
		trace('added basic $basic');
		addChild(basic);
		members.push(basic);
		return basic;
	}

	/**
	 * remove an object from the state
	 * @param basic object to remove
	 * @return Bool was it removed successfully
	 * @since 0.00.000
	 */
	public function remove(basic:Dynamic):Bool {
		if (basic == null)
			return false;
		if (contains(basic))
			removeChild(basic);
		members.remove(basic);
		return true;
	}

	/**
	 * destroy the state
	 * @since 0.00.000
	 */
	public function destroy() {
		// iterate a copy so removing mid-loop doesnt cause skips
		for (thing in members.copy()) {
			// call destroy on children that support it
			if (Std.isOfType(thing, AState))
				(cast thing : AState).destroy();
			else if (Reflect.hasField(thing, "destroy"))
				Reflect.callMethod(thing, Reflect.field(thing, "destroy"), []);

			// dispose BitmapData if it has any
			if (Reflect.hasField(thing, "bitmapData") && Reflect.field(thing, "bitmapData") != null)
				Reflect.callMethod(thing, Reflect.field(thing, "bitmapData"), []).dispose();

			// TODO: auto-remove event listeners added via in-line event listening.

			if (contains(thing))
				removeChild(thing);
		}
		members = [];

		// remove self from parent
		if (parent != null)
			parent.removeChild(this);
	}
}
