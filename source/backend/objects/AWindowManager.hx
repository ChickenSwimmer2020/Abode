package backend.objects;

import backend.ui.ATabStack;

/**
 * manager for in-window windows
 * @since 0.00.002
 */
class AWindowManager {
    /**
     * the window that is currently being dragged
     * @since 0.00.002
     */
    public static var heldWindow:Null<AWindow> = null;
    /**
     * all currently open windows
     * @since 0.00.002
     */
    public static var windows:Array<AWindow> = [];

    /**
     * initiate
     * @since 0.00.002
     */
    public function new() {
        if(windows == null) windows = [];
    }

    /**
     * add a window both to the manager and the stage
     * @param win window to add
     * @return AWindow window that was added
     * @since 0.00.006
     */
    public function addWindow(win:AWindow):AWindow {
        windows.push(win);
        Main.instance.addToMainStage(win);
        focusWindow(win);
        ASoundManager.playSound("assets/sounds/popup.wav", 1.0); //TODO: implement volume
        return win;
    }

    /**
     * make a new window, generally paired with `addWindow`
     * @param title window title 
     * @param x x
     * @param y y
     * @param w width
     * @param h height
     * @param borderless borderless
     * @param resizeable resizable
     * @return window that was made
     * @since 0.00.002
     */
    public inline function makeWindow(title:String, x:Int, y:Int, w:Int, h:Int, borderless:Bool=false, resizeable:Bool=false):AWindow return addWindow(new AWindow(title, x, y, w, h, borderless, resizeable));

    /**
     * prefab windows, for `makePrefabWindow`
     * @since 0.00.006
     */
    final prefabWindows:Map<String, Void->AWindow> = [
        "makeProject"=>()->{
            final width:Int = 775;
            final height:Int = (740/2).floor();
            var premade:AWindow = new AWindow("New Project", Main.pWidth/2-width/2, Main.pHeight/2-height/2, width, height, false, false);
            var tabGroup:ATabMenu = new ATabMenu(0, 0, new APoint(width/2, height));
                tabGroup.addGroup("Character Animation", new AGroup(0, 0)); //we dont use locales yet, fuck you copilot.
                tabGroup.addGroup("Social", new AGroup(0, 0));
                tabGroup.addGroup("Game", new AGroup(0, 0));
                tabGroup.addGroup("Web", new AGroup(0, 0));
                tabGroup.addGroup("Advanced", new AGroup(0, 0));
            premade.addContent(tabGroup);
            var detailsArea:ASprite = premade.addContent(new ASprite(width/2, 0).makeGraphic((width/2).floor(), height, AColor.BUTTON_DISABLED));
            premade.addContent(new AText(detailsArea.x+2, 2, detailsArea.width-10, "Details", 12));

            //TODO: if advanced, the units dropdown can be changed between
            /**
             * Inches,
             * Inches (decimal)
             * Points,
             * Centimeters,
             * Millimeters,
             * Pixels.
             */

            return premade;
        },
        "preferences"=>()->{
            final width:Int = (775/2).floor();
            final height:Int = (775/2).floor();
            var premade:AWindow = new AWindow(Locale.get("prefsWindow.title"), Main.pWidth/2-width/2, Main.pHeight/2-height/2, width, height, false, false);
            var tabGroup:ATabStack = new ATabStack(0, 0, new APoint(width, height));
                tabGroup.addGroup("General", new AGroup(0, 0)); //we dont use locales yet, fuck you copilot.
                tabGroup.addGroup("Code Editor", new AGroup(0, 0));
                tabGroup.addGroup("Scripter", new AGroup(0, 0));
                tabGroup.addGroup("Compiler", new AGroup(0, 0));
                tabGroup.addGroup("Text", new AGroup(0, 0));
                tabGroup.addGroup("Drawing", new AGroup(0, 0));
            premade.addContent(tabGroup);

            premade.addContent(new AButton(Locale.get("prefsWindow.cancel"), new Rectangle(width-85, height-45, 80, 20), (_:AButton)->{
                premade.destroy(); //cuz it cancels, so we dont save anything.
            }));
            premade.addContent(new AButton(Locale.get("prefsWindow.accept"), new Rectangle(width-170, height-45, 80, 20), (_:AButton)->{
                trace("TODO: save preferences");
            }));
            return premade;
        }
    ];

    /**
     * make a pre-made window, so we dont clutter other places in code.
     * @param type what prefab to use
     * @return AWindow the window that was generated
     * @since 0.00.006
     */
    public function makePrefabWindow(type:String):AWindow return addWindow(prefabWindows.get(type)());


    /**
     * focus a window to the front
     * @param w what window to focus
     * @since 0.00.002
     */
    public static function focusWindow(w:AWindow):Void {
        if (w == null || w.stage == null) return;

        w.stage.setChildIndex(w, w.stage.numChildren - 1); //didnt know i could do this!


        if (windows.contains(w)) {
            windows.remove(w);
            windows.push(w);
        }
    }
}

/**
 * an in-window window.
 * @since 0.00.002
 */
class AWindow extends AGroup<ASprite> {
    @:isVar public var dragBar(get, null):Null<ASprite>=null;
    public function get_dragBar():Null<ASprite> return dragBar??null;

    @:isVar public var dragBarButtons(get, null):Null<Array<AButton>>=null;
    public function get_dragBarButtons():Null<Array<AButton>> return dragBarButtons??null;

    @:isVar public var windowTitle(get, null):Null<AText> = null;
    public function get_windowTitle():Null<AText> return windowTitle??null;

    public var isBorderless(default, set):Bool = false;
    public function set_isBorderless(a:Bool):Bool {
        isBorderless = a;
        return isBorderless;
    }

    public var content:AGroup<ASprite>;
    public var TBHeight:Float = 0; 
    var dragOffset:APoint = new APoint(0, 0);

    public function new(title:String, x:Float, y:Float, w:Int, h:Int, borderless:Bool=false, resizeable:Bool=false) {
        super(x, y);
        isBorderless = borderless;

        if(!isBorderless) {
            dragBar = new ASprite(0, 0).makeGraphic(w, 20, AColor.WHITE);
            add(dragBar);
            windowTitle = new AText(0, 0, dragBar.width/2, title, 12);
            add(windowTitle);
            dragBarButtons = [];
            for(i in 0...3) {
                var b:AButton = new AButton('[SYM: ${["WIN_CLOSE", "WIN_MAX", "WIN_MIN"][i]}]', new Rectangle(dragBar.width-(20+(20*i)), 0, 20, 20), [
                    (_:AButton) -> {
                        destroy();
                    },
                    (_:AButton) -> {
                        trace("maximize");
                    },
                    (_:AButton) -> {
                        trace("minimize");
                    }
                ][i]);
                dragBarButtons.push(b);
                add(b);
            }

            Application.current.window.stage.addEventListener(MouseEvent.MOUSE_MOVE, dragBar_onMove);
            TBHeight = 20;
        }

        content = new AGroup(0, 0);
        add(content);
        content.add(new ASprite(0, TBHeight).makeGraphic(w, h, AColor.WHITE));
        content.scrollRect = new Rectangle(0, 0, w, h);

        // Bring to top whenever the user clicks anywhere inside this window
        this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
    }

    private function onMouseDown(e:MouseEvent) {
        AWindowManager.focusWindow(this);
    }

    var dragging:Bool = false;
    public function dragBar_onMove(a:MouseEvent) {
        if (dragBar == null) return;

        var localMouse = dragBar.globalToLocal(new APoint(a.stageX, a.stageY).toOpenflPoint());
        var isOverDragBar = dragBar.containsPoint(APoint.fromOpenflPoint(localMouse));

        for(button in dragBarButtons) {
            if(button.containsPoint(APoint.fromOpenflPoint(localMouse))) {
                return; //if the button is overlapped, cancel and dont drag.
            }
        }

        // convert raw stage coords into Main's virtual/local space
        var vx:Float = (a.stageX - Main.instance.x) / Main.instance.scaleX;
        var vy:Float = (a.stageY - Main.instance.y) / Main.instance.scaleY;

        if (a.buttonDown && isOverDragBar) {
            if (!dragging) {
                if(AWindowManager.heldWindow!=null) return; //dont even try.
                dragging = true;
                AWindowManager.focusWindow(this);
                // Record grab offset so window doesn't snap its top-left corner to the mouse
                dragOffset.x = vx - this.x;
                dragOffset.y = vy - this.y;
                AWindowManager.heldWindow = this;
            }
        } else {
            if (dragging && !a.buttonDown) {
                dragging = false;
                AWindowManager.heldWindow = null;
            }
        }

        if (dragging) {
            if(AWindowManager.heldWindow!=this) {
                trace("Held window isnt this! returning.");
                return;
            }
            setPosition(vx - dragOffset.x, vy - dragOffset.y);
        }
    }

    /**
     * set the window position
     * @param x x
     * @param y y
     * @since 0.00.002
     */
    override public function setPosition(x:Float, y:Float) {
        this.x = x;
        this.y = y;
        
        if(members != null) {
            for(i => member in members) {
                if(member == null){
                    trace('Tried to set position of member $i but it was null!\nMake sure it gets removed!!');
                    continue;
                }
                member.x = 0;
                member.y = 0;
            }
        }
        
        if(dragBarButtons != null && dragBar != null) {
            for(i => b in dragBarButtons) {
                b.x = dragBar.width - (20 + (20 * i));
                b.y = 0;
            }
        }
    }

    /**
     * add content to the window
     * @param a what to add
     * @return ASprite sprite that was added
     * @since 0.00.002
     */
    public function addContent(a:ASprite):ASprite {
        a.y += TBHeight;
        content.add(a);
        return a;
    }

    /**
     * destroy the window
     * @since 0.00.002
     */
    override public function destroy() {
        this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
        
        if(!isBorderless && Application.current != null && Application.current.window != null) {
            Application.current.window.stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragBar_onMove);
        }

        AWindowManager.windows.remove(this);
        if (this.parent != null) {
            this.parent.removeChild(this);
        }

        super.destroy();
    }
}