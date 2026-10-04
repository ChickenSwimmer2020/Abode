package backend.ui;

class ATabMenu extends ASprite {
    var order:Array<String> = []; //for positioning fixes
    var targetWidth:Float = 0;
    public function new(x:Float, y:Float, size:APoint) {
        super(x, y);
        makeGraphic(size.iX, size.iY, AColor.MENUBAR_DROPDOWN_BACKGROUND);
        targetWidth = size.x;
    }

    public var buttons:Map<String, AButton> = [];
    public var groups:Map<String, AGroup<Dynamic>> = [];
    public function addGroup(n:String, gr:AGroup<Dynamic>):AGroup<Dynamic> {
        groups.set(n, gr);
        order.push(n);
        gr.y+=20; //move it down
        //gr.scrollRect = new Rectangle(x, y+20, width, height-20); //so group cant render outside of the tabmenu

        var button:AButton = new AButton(n, new Rectangle(0, 0, 50, 20), (_:AButton)->{activeGroup = n;});
        buttons.set(n, button);
        addChild(gr);
        gr.visible = false;
        addChild(button);
        scaleButtons();
        if(activeGroup=="") activeGroup = n; //default to first added group.
        return gr;
    }
    public function removeGroup(a:String):Bool {
        var group = groups.get(a);
        groups.remove(a);
        var button = buttons.get(a);
        buttons.remove(a);
        order.remove(a);
        button.destroy();
        group.destroy();
        scaleButtons();

        return (groups.get(a)==null&&buttons.get(a)==null);
    }

    public var activeGroup(default, set):String = "";
    public function set_activeGroup(a:String):String {
        activeGroup = a;

        for(label=>group in groups) {
            if(label == a){
                group.visible=true;
                buttons.get(label).disabled=true;
            }
            else{
                group.visible=false;
                buttons.get(label).disabled=false;
            }
        }
        scaleButtons();

        return activeGroup;
    }

    private function scaleButtons() {
        if (order.length == 0) return;
        var w = targetWidth/order.length;
        for (i in 0...order.length) {
            var button = buttons.get(order[i]);
            button.width = w;   // set width first
            button.x = i * w;   // then position
        }
    }
}