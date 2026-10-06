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
            //for project creation.
            var projWidth:Int = 1280;
            var projHeight:Int = 720;
            var projFPS:Int = 30;


            //ui
            var projectWidthInput:ATextInputBox = null;
            var projectHeightInput:ATextInputBox = null;
            var projectFpsInput:ATextInputBox = null;
            var projectTypeDropdown:AButton = null;
            var projectMeasureDropdown:AButton = null;
            
            function onProjectCreate(){
                trace('Attempting to make a new ${projWidth}x$projHeight project @$projFPS FPS, platform: ${projectTypeDropdown?.label.text}, and measure type: ${projectMeasureDropdown?.label.text}');
            }

            final width:Int = 775;
            final height:Int = (740/2).floor();
            var premade:AWindow = new AWindow("New Project", Main.pWidth/2-width/2, Main.pHeight/2-height/2, width, height, false, false);
            var tabGroup:ATabMenu = new ATabMenu(0, 0, new APoint(width/2, height));
                    var charAnimGroup:AGroup<AButton> = new AGroup(0, 0);
                        charAnimGroup.add(new AButton("Standard\n640x480", new Rectangle(5, 5, 85, 85), (_:AButton)->{
                            trace('Standard project make!');
                        }));
                        charAnimGroup.add(new AButton("HD\n1280x720", new Rectangle(90+5, 5, 85, 85), (_:AButton)->{
                            trace('HD project make!');
                        }));
                        charAnimGroup.add(new AButton("Full HD\n1920x1080", new Rectangle(90+90+5, 5, 85, 85), (_:AButton)->{
                            trace('Full HD project make!');
                        }));
                        charAnimGroup.add(new AButton("4K\n3840x2160", new Rectangle(90+90+90+5, 5, 85, 85), (_:AButton)->{
                            trace('4K project make!');
                        }));
                tabGroup.addGroup("Character Animation", charAnimGroup); //we dont use locales yet, fuck you copilot.
                tabGroup.addGroup("Social", new AGroup(0, 0));
                tabGroup.addGroup("Game", new AGroup(0, 0));
                tabGroup.addGroup("Web", new AGroup(0, 0));
                tabGroup.addGroup("Advanced", new AGroup(0, 0));
            premade.addContent(tabGroup);
            var detailsArea:ASprite = premade.addContent(new ASprite(width/2, 0).makeGraphic((width/2).floor(), height, AColor.MENUBAR_DROPDOWN_BACKGROUND));
            premade.addContent(new AText(detailsArea.x+2, 2, detailsArea.width-10, "Details", 12));
            premade.addContent(new AText(detailsArea.x+2, 22, detailsArea.width-10, "Width", 12));
            projectWidthInput = cast premade.addContent(new ATextInputBox(detailsArea.x+2, 42, 20, (((detailsArea.width-10)/2)-10).floor(), "1280", "1280", 12, (_:String)->{
                trace('Target Project Width was changed to $_!');
                projWidth = Std.parseInt(_);
            }));
            premade.addContent(new AText((detailsArea.x+2)+(((detailsArea.width-10)/2)-10).floor()+15, 22, detailsArea.width-10, "Height", 12));
            projectHeightInput = cast premade.addContent(new ATextInputBox((detailsArea.x+2)+(((detailsArea.width-10)/2)-10).floor()+15, 42, 20, (((detailsArea.width-10)/2)-10).floor(), "720", "720", 12, (_:String)->{
                trace('Target Project Height was changed to $_!');
                projHeight = Std.parseInt(_);
            }));
            premade.addContent(new AText(detailsArea.x+2, 62, detailsArea.width-10, "Units", 12));
            projectTypeDropdown = cast premade.addContent(new AButton("Pixels", new Rectangle(detailsArea.x+2, 82, 120, 20), (_:AButton)->{
                ADropdown.openDropdownMenu(_, false, [
                    {text: "Inches", closeOnClick: true, func: (b:AButton)->_.label.text="Inches"},
                    {text: "Inches (Decimal)", closeOnClick: true, func: (b:AButton)->_.label.text="Inches (Decimal)"},
                    {text: "Points", closeOnClick: true, func: (b:AButton)->_.label.text="Points"},
                    {text: "Centimeters", closeOnClick: true, func: (b:AButton)->_.label.text="Centimeters"},
                    {text: "Millimeters", closeOnClick: true, func: (b:AButton)->_.label.text="Millimeters"},
                    {text: "Pixels", closeOnClick: true, func: (b:AButton)->_.label.text="Pixels"},
                ]);
            }));
            projectTypeDropdown.disabled=true; //disable button at creation.
            //so that changing the group will either enable or disable the dropdown.
            tabGroup.onGroupChange = (newGroup:String)->projectTypeDropdown.disabled=!(newGroup=="Advanced");
            premade.addContent(new AText((detailsArea.x+2)+(((detailsArea.width-10)/2)-10).floor()+15, 62, detailsArea.width-10, "Frame Rate", 12));
            projectFpsInput = cast premade.addContent(new ATextInputBox((detailsArea.x+2)+(((detailsArea.width-10)/2)-10).floor()+15, 82, 20, (((detailsArea.width-10)/2)-10).floor(), "30", "30", 12, (_:String)->{
                trace('Target Project FPS was changed to $_!');
                projFPS = Std.parseInt(_);
            }));
            premade.addContent(new AText(detailsArea.x+2, 102, detailsArea.width-10, "Platform Type", 12));
            projectMeasureDropdown = cast premade.addContent(new AButton("HScript 2.7", new Rectangle(detailsArea.x+2, 122, 120, 20), (_:AButton)->{
                ADropdown.openDropdownMenu(_, false, [
                    {text: "HScript 2.7", closeOnClick: true, func: (b:AButton)->_.label.text="HScript 2.7"},
                    {text: "seperator",  func: null},
                    {text: "HTML5", closeOnClick: true, func: (b:AButton)->_.label.text="HTML5"},
                ]);
            }));
            premade.addContent(new AButton("Create", new Rectangle(((detailsArea.x+detailsArea.width)-82), height-42, 80, 20), (_:AButton)->onProjectCreate(), ACCENT));


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