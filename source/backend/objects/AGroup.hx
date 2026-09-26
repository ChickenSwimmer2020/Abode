package backend.objects;

import backend.ui.AButton;
import openfl.display.DisplayObject;

class AGroup<T:DisplayObject> extends ASprite {
    public var members:Array<T>;
    public var maxSize(default, set):Int=-1;
    public function set_maxSize(a:Int):Int {
        maxSize = a;
        return a;
    }

    public function new(x:Float, y:Float, ?maxSize:Int) {
        super(x, y);
        members = []; //initiate.
        if(maxSize!=null){
            members.resize(maxSize);
            this.maxSize = maxSize;
        }
    }
    
    public function add(a:T):T {
        if(maxSize==-1 || members.length < maxSize){
            members.push(a);
            addChild(a);
        }else{
            trace('Couldnt add, group is full!');
        }
        return a;
    }
    public function remove(a:T):Bool {
        if(members.indexOf(a)==-1){
            trace('Couldnt remove $a from the group, its not in members!');
            return false;
        }
        var b = members.remove(a);
        removeChild(a);
        return b;
    }

    //overrides
    override public function destroy() {
        for(member in members) {
            switch(Type.getClass(member)) {
                case ASprite: 
                    members.remove(member);
                    removeChild(member);
                    cast(member, ASprite).destroy();
                case AButton: 
                    members.remove(member);
                    removeChild(member);
                    cast(member, AButton).destroy();      
                case AGroup: 
                    members.remove(member);
                    removeChild(member);
                    cast(member, AGroup<Dynamic>).destroy();  
                case AText:
                    members.remove(member);
                    removeChild(member);
                    cast(member, AText).destroy();   
                default: trace('Unknown class: ${Type.getClass(member)}');
            }
            
        }
        members = [];
        if(parent!=null) parent.removeChild(this);
        super.destroy();
    }
}