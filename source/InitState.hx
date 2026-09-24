package;

import backend.utils.AColor;
import backend.ui.AMenuBar;

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
            {colorTransform: AColor.BGDARKEN, offsets: new Rectangle(50, -100, 200, 200)}
        );
            

        toolBar = new AMenuBar(TOP, [
            {
                text: "File",
                size: new APoint(50, 20),
                onClick: ()->{trace("File Menu");}
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
                        {text: "Hands on Tutorial  >", func: ()->{trace('TODO: sub dropdown');}},
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
    }
}