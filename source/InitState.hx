package;

import backend.ui.ProjectBox;

class InitState extends AState {
    var wallpaperBackground:ASprite;
    var toolBar:AMenuBar;
    public function new() {
        super();
        Mouse.show();
        wallpaperBackground = new ASprite(0, 0).loadGraphic(ASprite.getDesktopWallpaper(1280, 720), true);
        add(wallpaperBackground);
        
        wallpaperBackground.applyLocalFilter(
            new Rectangle(wallpaperBackground.width-wallpaperBackground.width/2+150, 0, wallpaperBackground.width/3+200, wallpaperBackground.height),
            new BlurFilter(32, 8, 3),
            {colorTransform: AColor.MAINMENU_PROJECTSLIST_DARKEN, offsets: new Rectangle(50, -100, 200, 200)}
        );
            
        toolBar = new AMenuBar(TOP, [
            {
                text: "File",
                size: new APoint(50, 20),
                onClick: ()->{
                    toolBar.openDropdownMenu(0, [
                        {text: "New...", keys:[Keyboard.CONTROL, Keyboard.N], func: ()->{
                            trace("Make new project.");
                        }},
                        {text: "New from template...", func: ()->{
                            trace("make new project with template.");
                        }},
                        {text: "Open", func: ()->{
                            trace('Open project from file.');
                        }},
                        {text: "Open Recent > ", closeOnClick: false, func: ()->{
                            trace('TODO: sub dropdown.');
                        }},
                        {text: "Close", disabled: true, func: ()->{
                            trace('Close current project.');
                        }},
                        {text: "Close All", disabled: true, func: ()->{
                            trace('Close all opened projects.');
                        }},
                        {text: "Save", disabled: true, func: ()->{
                            trace('Save current project.');
                        }},
                        {text: "Save as...", disabled: true, func: ()->{
                            trace('Save project as a different file.');
                        }},
                        {text: "Save as template...", disabled: true, func: ()->{
                            trace('Save project as a new template.');
                        }},
                        {text: "Revert", disabled: true, func: ()->{
                            trace('Unsure what this does. is it like an undo button?');
                        }},
                        {text: 'seperator', func: null},
                        {text: "Import > ", closeOnClick: false, func: ()->{
                            trace('TODO: sub dropdown');
                        }},
                        {text: "Export > ", closeOnClick: false, func: ()->{
                            trace('TODO: sub dropdown');
                        }},
                        {text: 'seperator', func: null},
                        {text: "Convert to > ", closeOnClick: false, func: ()->{
                            trace('TODO: sub dropdown');
                        }},
                        {text: 'seperator', func: null},
                        {text: "Distribution Settings...", func: ()->{
                            trace('Publish settings but legally distinct');
                        }},
                        {text: "Distribute", func: ()->{
                            trace('Publish legally distinct');
                        }},
                        {text: 'seperator', func: null},
                        {text: "HScript Settings...", func: ()->{
                            trace('ActionScript settings');
                        }},
                        {text: 'seperator', func: null},
                        {text: "Exit", func: ()->{
                            trace('Exit program');
                        }},
                    ], 200);
                }
            },
            {
                text: "Edit",
                size: new APoint(50, 20),
                onClick: ()->{trace("Edit menu");}
            },
            {
                text: "View",
                size: new APoint(50, 20),
                onClick: ()->{trace("View menu");}
            },
            {
                text: "Insert",
                size: new APoint(50, 20),
                onClick: ()->{trace("Insert menu");}
            },
            {
                text: "Modify",
                size: new APoint(50, 20),
                onClick: ()->{trace("Modify menu");}
            },
            {
                text: "Text",
                size: new APoint(50, 20),
                onClick: ()->{trace("Text menu");}
            },
            {
                text: "Commands",
                size: new APoint(50, 20),
                onClick: ()->{trace("Commands menu");}
            },
            {
                text: "Control",
                size: new APoint(50, 20),
                onClick: ()->{trace("Controls menu");}
            },
            {
                text: "Debug",
                size: new APoint(50, 20),
                onClick: ()->{trace("Debug menu");}
            },
            {
                text: "Window",
                size: new APoint(50, 20),
                onClick: ()->{trace("Window menu");}
            },
            {
                text: "Help",
                size: new APoint(50, 20),
                onClick: ()->{
                    toolBar.openDropdownMenu(10, [
                        {text: "Abode Help", func: ()->{trace('Help menu dropdown object 1!');}},
                        {text: "Submit bug report/feature request...", func: ()->{trace('Help menu dropdown object 2!');}},
                        {text: 'seperator', func: null},
                        {text: "Online Tutorial...", func: ()->{trace('Help menu dropdown object 2!');}},
                        {text: "Hands on Tutorial  >", closeOnClick: false, func: ()->{trace('TODO: sub dropdown');}},
                        {text: 'seperator', func: null},
                        {text: "Manage Plugins", func: ()->{trace('TODO: sub dropdown');}},
                        {text: 'seperator', func: null},
                        {text: "Check for Updates...", func: ()->{trace('TODO: sub dropdown');}},
                        {text: 'seperator', func: null},
                        {text: "About Abode", func: ()->{trace('TODO: about program popup');}},
                    ], 200);
                }
            }
        ]);
        add(toolBar);


        add(new ProjectBox(Main.pWidth-350, 35)); //for testing and getting it ready.

    }
}