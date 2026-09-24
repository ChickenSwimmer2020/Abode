package backend.debug;

class DebugDisplay extends Sprite {
    private var label:TextField;
    private var frameCount:Int = 0;
    private var fps:Float = 0;
    private var fpsTimer:Float = 0;
    private var lastTime:Int = 0;

    public function new() {
        super();

        // background
        graphics.beginFill(0x000000, 0.6);
        graphics.drawRect(0, 0, 200, 80);
        graphics.endFill();

        // text field
        label = new TextField();
        label.defaultTextFormat = new TextFormat("_typewriter", 11, 0x00FF00);
        label.width = 200;
        label.height = 80;
        label.selectable = false;
        label.mouseEnabled = false;
        addChild(label);

        lastTime = openfl.Lib.getTimer();
        addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }



    static var MSGS:Array<Dynamic> = [];
    var finalMsg:String = "";
    private function onEnterFrame(e:Event):Void {
        var now = openfl.Lib.getTimer();
        var dt = (now - lastTime) / 1000.0;
        lastTime = now;

        frameCount++;
        fpsTimer += dt;

        if (fpsTimer >= 0.5) { // update every 0.5 seconds
            fps = frameCount / fpsTimer;
            frameCount = 0;
            fpsTimer = 0;
        }

        var mem = System.totalMemory / 1024 / 1024; // bytes to MB

        //terrible way to do it, TODO: optimize this. 
        if(MSGS!=([{key: "FPS", value: Math.round(fps)},{key: "STA", value: Main.StateSystem.currentState},{key: "MEM||MB", value: (Math.round(mem * 10) / 10)},{key: "STG||children", value: ((stage!=null)?stage.numChildren:0)},{key: "OBJ||children", value: numChildren}]:Array<Dynamic>)){
            MSGS = ([
                {key: "FPS", value: Math.round(fps)},
                {key: "STA", value: Main.StateSystem.currentState},
                {key: "MEM||MB", value: (Math.round(mem * 10) / 10)},
                {key: "STG||children", value: ((stage!=null)?stage.numChildren:0)},
                {key: "OBJ||children", value: numChildren}
            ]:Array<Dynamic>);
        }

        if(finalMsg!="") finalMsg="";
        for(label in MSGS) finalMsg += '${label.key.split('||')[0]}:    ${label.value} ${label.key.split('||')[1]??""}\n';
        if(label.height!=(0+(20*(MSGS.length-1)))){ //only update the graphics if we need too.
            label.height=(0+(20*(MSGS.length-1)));
            graphics.clear();
            graphics.beginFill(0x000000, 0.6);
                graphics.drawRect(0, 0, 200, label.height);
            graphics.endFill();
        }
        label.text = finalMsg;
    }

    public function destroy():Void {
        removeEventListener(Event.ENTER_FRAME, onEnterFrame);
        if (parent != null) parent.removeChild(this);
    }
}