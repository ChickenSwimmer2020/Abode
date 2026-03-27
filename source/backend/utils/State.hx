package backend.utils;

import openfl.display.Sprite;

class State extends Sprite {
    public var members:Array<Dynamic> = [];

    public function new() {
        super();
    }

    public function add(basic:Dynamic):Dynamic {
        trace('added basic $basic');
        addChild(basic);
        members.push(basic);
        return basic;
    }

    public function remove(basic:Dynamic):Bool {
        if (basic == null) return false;
        if (contains(basic))
            removeChild(basic);
        members.remove(basic);
        return true;
    }

    public function destroy() {
        // iterate a copy so removing mid-loop doesnt cause skips
        for (thing in members.copy()) {
            // call destroy on children that support it
            if (Std.isOfType(thing, State))
                (cast thing:State).destroy();
            else if (Reflect.hasField(thing, "destroy"))
                Reflect.callMethod(thing, Reflect.field(thing, "destroy"), []);

            // dispose BitmapData if it has any
            if (Reflect.hasField(thing, "bitmapData") && Reflect.field(thing, "bitmapData") != null)
                Reflect.callMethod(thing, Reflect.field(thing, "bitmapData"), []).dispose();

            if (contains(thing))
                removeChild(thing);
        }
        members = [];

        // remove self from parent
        if (parent != null)
            parent.removeChild(this);
    }
}