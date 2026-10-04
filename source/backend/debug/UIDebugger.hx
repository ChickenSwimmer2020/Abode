package backend.debug;

class UIDebugger extends AState {
    var background:ASprite;

    var testingButton:AButton;
    var testingDropdown:AMenuBar;
    var testingInput:ATextInputBox;
    public function new() {
        super();
        Main.addKeyPressed("UIDebuggerExitKey", Keyboard.ESCAPE, true, (_:KeyboardEvent)->{
            Main.StateSystem.switchState(InitState);
        });
        background = new ASprite(0, 0).makeGraphic(Main.pWidth, Main.pHeight, AColor.LOADINGIND_MAINCOLOR);
        add(background);

        add(testingButton = new AButton("Testing", new Rectangle(0, 20, 80, 20), (a:AButton)->{
            trace("This button works!");
        }));

        testingDropdown = new AMenuBar(TOP, [
            {type: ABUTTON, text: "Button", size: new APoint(100, 20), onClick: (_)->{trace("Normal button go brr!!");}},
            {type: ABUTTON, text: "Dropdown", size: new APoint(100, 20), onClick: (_)->{
                ADropdown.openDropdownMenu(_, [
                    {text: "button", closeOnClick: false, keys: [], disabled: false, func: (_)->{trace("dropdown button");}},
                    {text: "button(Close)", closeOnClick: true, keys: [], disabled: false, func: (_)->{trace("dropdown button (closeOnClick)");}},
                    {text: "button(Disabled)", closeOnClick: false, keys: [], disabled: true, func: (_)->{trace("dropdown button (closeOnClick)");}},
                    {text: "seperator", closeOnClick: false, keys: [], disabled: true, func: null},
                    {text: "Sub dropdown", closeOnClick: false, keys: [], disabled: false, func: (b)->{
                        ADropdown.openSubDropdownMenu(b, [
                            {text: "sub button", closeOnClick: false, keys: [], disabled: false, func: (_)->{trace("sub dropdown button");}},
                            {text: "seperator", closeOnClick: false, keys: [], disabled: true, func: null},
                            {text: "sub button(Close)", closeOnClick: true, keys: [], disabled: false, func: (_)->{trace("sub dropdown button (closeOnClick)");}},
                            {text: "seperator", closeOnClick: false, keys: [], disabled: true, func: null},
                            {text: "sub button(Disabled)", closeOnClick: false, keys: [], disabled: true, func: (_)->{trace("sub dropdown button (closeOnClick)");}},
                            {text: "seperator", closeOnClick: false, keys: [], disabled: true, func: null},
                            {text: "sub button(Close full)", closeOnClick: false, closeFullDropdown: true, keys: [], disabled: false, func: (_)->{trace("sub dropdown button (close full dropdown)");}},         
                        ]);
                    }},
                ]);
            }},
        ]);
        add(testingDropdown);

        add(testingInput = new ATextInputBox(80, 20, 20, 500, null, "input test!", 12, (_:String)->{
            trace('Submitting a textbox with text: "$_"');
        }));
    }
}