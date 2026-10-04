package;

class Main extends Sprite {
    public static final desktopbackgroundImage:BitmapData = ASprite.getDesktopWallpaper(1280, 720);
    private static var onKeyPressed:Map<String, {k:String, ar:Bool, c:KeyboardEvent->Void}>;
    public static function addKeyPressed(a:String, k:Dynamic, autoRemove:Bool=true, c:KeyboardEvent->Void){
        try{
            if(onKeyPressed==null) onKeyPressed=new Map<String, {k:String,ar:Bool,c:KeyboardEvent->Void}>();
            if(onKeyPressed.get(a)!=null) return; //cuz it already exists, so why add it again?
            onKeyPressed.set(a, {k: Std.string(k), ar: autoRemove, c: c});
            trace('added "$a" to keyboard listener.');
        }catch(e:Exception) traceError(e);
    }
    public static function removeKeyPressed(a:String):Bool{
        try{
            onKeyPressed.remove(a);
            trace('removed "$a" from keyboard listener.');
            return (onKeyPressed.get(a)==null);
        }catch(e:Exception) traceError(e);
        return false;
    }

    public static var instance:Main;
    public static var pWidth:Int=1280; //programWidth //? these are seperate from the window w/h.
    public static var pHeight:Int=720; //programHeight //? since these calculate the internal size of state and such.
    public static var vMouse:APoint = new APoint(0, 0);
    public static var windowManager:AWindowManager;
    #if debug
        public var stats:DebugDisplay;
    #end
    //CONTROLLERS (very weird system, but it works \_シ_/)
    public static var StateSystem:StateSystemInit = new StateSystemInit(null); //defaults to splashscreen since thats literally the only thing it does on init
    public function new() {
        super();
        try{
            Native.flashTaskbar();
            Log.throwErrors = false; //STOP CRASHING MAH GAME!
            instance = this;
            #if (hl && !debug) hl.UI.closeConsole(); #end
            stage.scaleMode = #if html5 StageScaleMode.EXACT_FIT; #else StageScaleMode.NO_SCALE; #end
            stage.align = StageAlign.TOP_LEFT;
            scrollRect = new Rectangle(0, 0, 1280, 720);
            Lib.application.window.onClose.add(onClosing);
            stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
            stage.addEventListener(Event.RESIZE, onStageResize);
            stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
            stage.addEventListener(MouseEvent.CLICK, onMouseClick);
            onStageResize(null); // apply once at startup
            Application.current.window.title = '${Application.current.window.title}: [${Application.current.meta.get("version")}]';

            ATween.globalParent = this; //so that new Tween() will auto-destroy and not cause memory leaks.
            windowManager = new AWindowManager();

            addChild(StateSystem);
            StateSystem.switchState(SplashScreen); //wait fuck this might work!

            #if debug
                stats = new DebugDisplay();
                stage.addChild(stats); // add to stage directly so it's always on top
                stats.x = 10;
                stats.y = 10;
                stats.visible = UPrefs.debuggerVisible.value;
            #end

            Mouse.hide();
        }catch(e:Exception) traceError(e);
    }
    private function onKeyDown(e:KeyboardEvent) {
        try{
            #if debug if(e.keyCode == Keyboard.F1) stats.visible=!stats.visible; UPrefs.debuggerVisible.value=stats.visible; #end

            if(onKeyPressed!=null) {
                for(label=>info in onKeyPressed) {
                    if(label==null || info==null) continue;
                    if(info.k=="*") {
                        if(info.c!=null) {
                            info.c(e);
                            info.ar?removeKeyPressed(label):null;
                        }else{
                            trace('Null info found with $label!!');
                        }
                    }else{
                        var tk:Null<Int> = Std.parseInt(info.k);
                        if(tk==null) {
                            trace('Couldnt parse ${info.k} on $label, so we\'re skipping it.');
                            continue;
                        }
                        if(e.keyCode == tk) {
                            if(info.c!=null) {
                                info.c(e);
                                info.ar?removeKeyPressed(label):null;
                            }else{
                                trace('Null info found with $label!!');
                            }
                        }else continue;
                    }
                }
            }

            if(ADropdown.dropdownOpen){ //TODO: fix this.
                for(keys=>targetOption in ADropdown.dropdownKeys) {

                    if(!keys.contains(e.keyCode) && (!e.shiftKey && (!e.altKey && !e.controlKey))) {
                        if(ADropdown.canCloseInstace) ADropdown.closeDropdownMenu(); //force close any open instance.
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
        }catch(e:Exception) traceError(e);
    }
    private function onMouseClick(e:MouseEvent) {
        try{
            if(ADropdown.subDropdownOpen && ADropdown.canCloseSubInstace) {
                if(!ADropdown.subDropdownBG.containsMouse()){ //if off the backing, then exit.
                    ADropdown.closeSubDropdownMenu(); //force close any open instance.
                }else{
                    for(object in ADropdown.members) {
                        if(object == ADropdown.subDropdownBG) continue; //skip it and dont increase index
                        var obj:ASprite = cast(object, ASprite);
                        if(obj.containsMouse()) {
                            if(cast(obj.getAttribute("closeFullDropdown"), Bool)==true) {
                                ADropdown.closeSubDropdownMenu();
                                ADropdown.closeDropdownMenu(); //cuz, close the whole thing.
                            }
                            if(cast(obj.getAttribute("isSubDropdownObject"), Bool) == true){
                                if(cast(obj.getAttribute("closeOnClick"), Bool) == true){
                                    ADropdown.closeSubDropdownMenu();
                                }else{
                                    continue;
                                }
                            }else{
                                continue;
                            }
                        }
                    }
                }
            }else if(ADropdown.dropdownOpen && ADropdown.canCloseInstace){
                if(!ADropdown.dropdownBG.containsMouse()){ //if off the backing, then exit.
                    ADropdown.closeDropdownMenu(); //force close any open instance.
                }else{
                    for(object in ADropdown.members) {
                        if(object == ADropdown.dropdownBG) continue; //skip it and dont increase index
                        var obj:ASprite = cast(object, ASprite);
                        if(obj.containsMouse()) {
                            if(cast(obj.getAttribute("isDropdownObject"), Bool) == true){
                                if(cast(obj.getAttribute("closeOnClick"), Bool) == true){
                                    ADropdown.closeDropdownMenu();
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
            
            if(ATextInputBox.selectedTextBox != null && !ATextInputBox.selectedTextBox.containsMouse()) {
                ATextInputBox.selectedTextBox = null; //deselect the textbox if we click out of it
            }
        }catch(e:Exception) traceError(e);
    }

    

    //OPENFL's actual scale mode for Stage is ASS AF. so we're gonna do it properly.
    private function onStageResize(_:Event):Void {
        try{
            #if sys
                var w = stage.stageWidth;
                var h = stage.stageHeight;
                var s = Math.min(w / pWidth, h / pHeight);


                scaleX = scaleY = s;
                x = (w - pWidth * s) / 2;
                y = (h - pHeight * s) / 2;
            #elseif html5
                pWidth = Application.current.window.width;
                pHeight = Application.current.window.height;
            #end
            updateVirtualMouse();
        }catch(e:Exception) traceError(e);
    }
    private function onStageMouseMove(_:MouseEvent):Void {
        try{ updateVirtualMouse(); }catch(e:Exception) traceError(e);
    }
    private inline function updateVirtualMouse():Void {
        try{
            vMouse.x = (stage.mouseX - x) / scaleX;
            vMouse.y = (stage.mouseY - y) / scaleY;
        }catch(e:Exception) traceError(e);
    }
    public function addToMainStage(a:DisplayObject) {
        try{ addChild(a); }catch(e:Exception) traceError(e);
    }
    public function removeFromMainStage(a:DisplayObject) {
        try{ removeChild(a); }catch(e:Exception) traceError(e);
    }

    public function onClosing() {
        try{
            #if debug
                stats.destroy();
            #end

            stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMove);
            stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
            stage.removeEventListener(Event.RESIZE, onStageResize);
            Lib.application.window.onClose.remove(onClosing);
        }catch(e:Exception) traceError(e);
    }

    public static function traceError(e:Exception) {
        trace('AN ERROR OCCURED: ${e.message}');
        trace('WITH STACK: ${e.stack.toString()}');
    }
}