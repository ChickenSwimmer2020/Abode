package backend.objects;

/**
 * the starting state of everything, this is initilized in Main
 * @since 0.00.000
 */
class StateSystemInit extends Sprite {
	/**
	 * the currently loaded state, as a string!
	 * (Used for debugging)
	 * @since 0.00.001
	 */
	public var currentState:String = "UNKNOWN!!";

	/**
	 * the currently loaded state
	 * @since 0.00.000
	 */
	public var state:HState;

	/**
	 * initilize the state system
	 * @param state what state to load (can be null)
	 * @since 0.00.000
	 */
	public function new(state:Null<Class<HState>>) {
		super();
		if (state == null) {
			this.state = new HState();
		} else {
			this.state = Type.createInstance(state, []);
		}
		addChild(this.state); // moved out — always add it
		currentState = this.state.toString().replace("[", "").replace(']', "").replace('object', "").trim();
	}

	/**
	 * switch to a new state
	 * @param state state to switch to
	 * @since 0.00.000
	 */
	public function switchState(state:Class<HState>, ?args:Array<Dynamic>) {
		// clean up old state
		this.state.destroy();
		if (contains(this.state))
			removeChild(this.state);
		this.state = null; // let GC collect it

		// create and add new state
		this.state = Type.createInstance(state, args??[]);
		addChild(this.state);
		currentState = this.state.toString().replace("[", "").replace(']', "").replace('object', "").trim();
	}
}
