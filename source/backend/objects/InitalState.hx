package backend.objects;

class StateSystemInit extends Sprite {
    public var currentState:String = "UNKNOWN!!";
    public var state:AState;

    public function new(state:Null<Class<AState>>) {
        super();
        if (state == null) {
            this.state = new AState();
        } else {
            this.state = Type.createInstance(state, []);
        }
        addChild(this.state); // moved out — always add it
        currentState = this.state.toString().replace("[", "").replace(']', "").replace('object', "").trim();
    }

    public function switchState(state:Class<AState>) {
        // clean up old state
        this.state.destroy();
        if (contains(this.state))
            removeChild(this.state);
        this.state = null; // let GC collect it

        // create and add new state
        this.state = Type.createInstance(state, []);
        addChild(this.state);
        currentState = this.state.toString().replace("[", "").replace(']', "").replace('object', "").trim();
    }
}