package backend.utils;

import openfl.display.Sprite;

class State extends Sprite {
    public var members:Array<Dynamic>=[];

    public function new() {
        super(); //doesnt really do anything lol.
    }
    /**
     * add an object to the members array
     * @param basic object to add
     * @return object (for chaining ic you like that i guess)
     */
    public function add(basic:Dynamic):Dynamic {
        trace('added basic $basic');
        addChild(basic);
        members.push(basic);
        return basic; // for chaining i guess.
    }
    /**
     * remove a sprite from the members array
     * @param basic object to remove
     * @return Bif object was removed successfully.
     */
    public function remove(basic:Dynamic):Bool {
        if(basic!=null){
            removeChild(basic);
            members.remove(basic);
            return true;
        }else return true;
        return false;
    }

    public function destroy() {
        for(thing in members) {
            remove(thing);
        }
        members=[];
    }
}