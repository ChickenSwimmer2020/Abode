package backend.utils;

import openfl.display.Sprite;

class StateSystemInit extends Sprite {
    public var state:State;

    public function new(state:Null<Class<State>>) {
        super();
        if(state==null){
            this.state = new State(); //just init it. dont want a null state now do we.
        }else{
            this.state = Type.createInstance(state, []);
            addChild(this.state);
        }
    }

    public function switchState(state:Class<State>) {
        this.state.destroy();
        removeChild(this.state); //because it clears items i think.
        this.state = null;
        this.state = new State();
        this.state = Type.createInstance(state, []); //shouldnt need to readd the child.
        if(!contains(this.state)) addChild(this.state); //fallback incase state didnt get added originally (from new)
    }
}