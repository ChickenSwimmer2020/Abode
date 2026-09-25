package;

class Main extends Sprite {
    public static var pWidth:Int=1280; //programWidth //? these are seperate from the window w/h.
    public static var pHeight:Int=720; //programHeight //? since these calculate the internal size of state and such.

    #if debug
        public var stats:DebugDisplay;
    #end
    //CONTROLLERS (very weird system, but it works \_シ_/)
    public static var StateSystem:StateSystemInit = new StateSystemInit(null); //defaults to splashscreen since thats literally the only thing it does on init
    public function new() {
        super();
        stage.scaleMode = StageScaleMode.NO_SCALE;
        stage.align = StageAlign.TOP_LEFT;
        scrollRect = new Rectangle(0, 0, 1280, 720);
        stage.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);
        stage.addEventListener(ErrorEvent.ERROR, onError);
        Lib.application.window.onClose.add(onClosing);
        stage.addEventListener(Event.RESIZE, onStageResize);
        stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        stage.addEventListener(MouseEvent.CLICK, onMouseClick);
        onStageResize(null); // apply once at startup

        ATween.globalParent = this; //so that new Tween() will auto-destroy and not cause memory leaks.
        

        addChild(StateSystem);
        StateSystem.switchState(SplashScreen); //wait fuck this might work!

        #if debug
            stats = new DebugDisplay();
            stage.addChild(stats); // add to stage directly so it's always on top
            stats.x = 10;
            stats.y = 10;
        #end

        Mouse.hide();
    }
    private function onKeyDown(e:KeyboardEvent) {
        #if debug if(e.keyCode == Keyboard.F1) stats.visible=!stats.visible; #end

        if(AMenuBar.dropdownOpen){ //TODO: fix this.
            for(keys=>targetOption in AMenuBar.instance.dropdownKeys) {

                if(!keys.contains(e.keyCode) && (!e.shiftKey && (!e.altKey && !e.controlKey))) {
                    if(AMenuBar.canCloseInstace) AMenuBar.instance.closeDropdownMenu(); //force close any open instance.
                }else{
                    var targetKeys:Array<Bool>=[]; 
                    var allKeys:Array<Int> = keys;
                    for(key in allKeys) {
                        if(key == Keyboard.CONTROL){
                            targetKeys.push(e.controlKey);
                            allKeys.splice(allKeys.indexOf(17), 1);
                            continue;
                        }
                        if(key == Keyboard.ALTERNATE){
                            targetKeys.push(e.altKey);
                            allKeys.splice(allKeys.indexOf(18), 1);
                            continue;
                        }
                        if(key == Keyboard.SHIFT){
                            targetKeys.push(e.shiftKey);
                            allKeys.splice(allKeys.indexOf(16), 1); //remove the key from the array
                            continue; //then skip over the index
                        }
                        //targetKeys.push((e.keyCode == e.));
                        allKeys.splice(allKeys.indexOf(e.keyCode), 1); //remove the key from the array
                    }

                    trace(targetKeys);

                    //if(targetKeys.allTrue())
                    //AMenuBar.instance.buttons.get(targetOption).onC();
                }
            }
        }

        
    }
    private function onMouseClick(e:MouseEvent) {
        if(AMenuBar.dropdownOpen && AMenuBar.canCloseInstace){
            if(AMenuBar.instance==null) {
                trace("Tried to close an instance of AMenuBar but instance is null!");
                return;
            }
            if(!AMenuBar.instance.dropdownBG.containsPoint(new APoint(e.stageX, e.stageY))){ //if off the backing, then exit.
                AMenuBar.instance.closeDropdownMenu(); //force close any open instance.
            }else{
                for(object in AMenuBar.instance.members) {
                    if(object == AMenuBar.instance.dropdownBG) continue; //skip it and dont increase index
                    if(object.containsPoint(new APoint(e.stageX, e.stageY))) {
                        if(cast(object.getAttribute("isDropdownObject"), Bool) == true){
                            if(cast(object.getAttribute("closeOnClick"), Bool) == true){
                                AMenuBar.instance.closeDropdownMenu();
                            }else{
                                continue;
                            }
                        }else{
                            continue;
                        }
                    }
                }
            }
        }
    }

    

    //OPENFL's actual scale mode for Stage is ASS AF. so we're gonna do it properly.
    private function onStageResize(_:Event):Void {
        var w = stage.stageWidth;
        var h = stage.stageHeight;
        var s = Math.min(w / pWidth, h / pHeight);


        scaleX = scaleY = s;
        x = (w - pWidth * s) / 2;
        y = (h - pHeight * s) / 2;
    }

    public function onError(event:ErrorEvent) {
        trace('CAUGHT ERROR: ' + event.toString());
        #if sys
        Sys.println('CAUGHT ERROR: ' + event.toString());
        #end
        event.preventDefault();
        event.stopImmediatePropagation();
    }

    public function onUncaughtError(event:UncaughtErrorEvent) {
        trace('UNCAUGHT ERROR: ' + event.error);
        #if sys
        Sys.println('UNCAUGHT ERROR: ' + event.error);
        #end
        event.preventDefault();
        event.stopImmediatePropagation();
    }

    public function onClosing() {
        #if debug
            stats.destroy();
            
        #end

        stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
        stage.removeEventListener(Event.RESIZE, onStageResize);
        Lib.application.window.onClose.remove(onClosing);
        stage.removeEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);
        stage.removeEventListener(ErrorEvent.ERROR, onError);
    }
}