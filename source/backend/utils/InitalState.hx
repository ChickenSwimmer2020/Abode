package backend.utils;

import openfl.display.Sprite;

class StateSystemInit extends Sprite {
    public var state:State;

    public function new(state:Null<Class<State>>) {
        super();
        if (state == null) {
            this.state = new State();
        } else {
            this.state = Type.createInstance(state, []);
        }
        addChild(this.state); // moved out — always add it
    }

    public function switchState(state:Class<State>) {
        // clean up old state
        this.state.destroy();
        if (contains(this.state))
            removeChild(this.state);
        this.state = null; // let GC collect it

        // create and add new state
        this.state = Type.createInstance(state, []);
        addChild(this.state);
    }
}