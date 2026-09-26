package;

import backend.ui.ScrollableArea;
import backend.Network;
import backend.ui.AButton;
import lime.graphics.RenderContext;
import lime.ui.Window;
import backend.objects.AWindowManager;
import backend.objects.ASound;
import backend.ui.ProjectBox;

class InitState extends AState {
    var wallpaperBackground:ASprite;
    var toolBar:AMenuBar;
    public function new() {
        super();
        ASound.playMusic("assets/sounds/Vectors.wav", 0.35);
        Mouse.show();
        wallpaperBackground = new ASprite(0, 0).loadGraphic(ASprite.getDesktopWallpaper(1280, 720), true);
        add(wallpaperBackground);
        #if html5 wallpaperBackground.setGraphicSize(Main.pWidth, Main.pHeight); #end
        
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
                        #if sys
                            {text: 'seperator', func: null},
                            {text: "Exit", func: ()->{
                                trace('Exit program');
                            }},
                        #end
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
            #if sys
                {
                    text: "Window",
                    size: new APoint(50, 20),
                    onClick: ()->{trace("Window menu");}
                },
            #end
            {
                text: "Help",
                size: new APoint(50, 20),
                onClick: ()->{
                    toolBar.openDropdownMenu(#if(html5)9#else 10#end, [
                        {text: "Abode Help", func: ()->{trace('Help menu dropdown object 1!');}},
                        {text: "Submit bug report/feature request...", func: ()->{trace('Help menu dropdown object 2!');}},
                        {text: 'seperator', func: null},
                        {text: "Online Tutorial...", func: ()->{trace('Help menu dropdown object 2!');}},
                        {text: "Hands on Tutorial  >", closeOnClick: false, func: ()->{trace('TODO: sub dropdown');}},
                        {text: 'seperator', func: null},
                        {text: "Manage Plugins", func: ()->{trace('TODO: sub dropdown');}},
                        {text: 'seperator', func: null},
                        {text: "Check for Updates...", func: ()->{
                            var value:Int = Network.checkForUpdates();

                            var darkenSprite:ASprite = new ASprite(0, 0).makeGraphic(Main.pWidth, Main.pHeight, 0x6E000000);
                            Main.instance.addToMainStage(darkenSprite);
                            var loader:LoadingIndicator = new LoadingIndicator(0, 0);
                            Main.instance.addToMainStage(loader);
                            loader.screenCenter();

                            final time:Float = 5.0;
                            ATimer.start(time/2, ()->{
                                if(value<=-1){
                                    loader.destroy();
                                    darkenSprite.setGraphicColor(0x6EFF0000);
                                    var text:AText = new AText(0, 0, Main.pWidth, "", 48);
                                    Main.instance.addToMainStage(text);
                                    text.height = 200; //TODO: make this automatic properly.
                                    text.text = switch(value) {
                                        case -1: "Couldnt connect to URL";
                                        case -4: "404 Couldnt find requested file\nor no connection";
                                        case -5: "Something went wrong.\nWe dont know what.\n:/";
                                        default: "Generic error message\nWe have no clue what just happened.";
                                    }
                                    text.alignment = CENTER;
                                    text.x = Main.pWidth/2-text.width/2;
                                    text.y = Main.pHeight/2-text.height/2;

                                    ATimer.start(2.5, ()->{
                                        new ATween().tween(darkenSprite, {alpha: 0}, 1.15, ()->{
                                            darkenSprite.destroy();
                                        }, AEase.expoInOut);

                                        new ATween().tween(text, {alpha: 0}, 1.15, ()->{
                                            text.destroy();
                                        }, AEase.expoInOut);
                                    });
                                }
                            });

                            ATimer.start(time, ()->{
                                switch(value){
                                    case 1:
                                        loader.destroy();
                                        darkenSprite.setGraphicColor(0x6E00FF00);
                                        var text:AText = new AText(0, 0, Main.pWidth, "", 48);
                                        Main.instance.addToMainStage(text);
                                        text.text = "Runing latest version!";
                                        text.alignment = CENTER;
                                        text.x = Main.pWidth/2-text.width/2;
                                        text.y = Main.pHeight/2-text.height/2;

                                        ATimer.start(0.75, ()->{
                                            new ATween().tween(darkenSprite, {alpha: 0}, 0.575, ()->{
                                                darkenSprite.destroy();
                                            }, AEase.expoInOut);

                                            new ATween().tween(text, {alpha: 0}, 0.575, ()->{
                                                text.destroy();
                                            }, AEase.expoInOut);
                                        });
                                    case 0:
                                        new ATween().tween(darkenSprite, {alpha: 0}, 0.575, ()->{
                                            darkenSprite.destroy();
                                            var updateWindow:AWindow = Main.windowManager.makeWindow("Update Available!", Math.floor(Main.pWidth/2-640/2), Math.floor(Main.pHeight/2-360/2), 640, 360, false, false);
                                        }, AEase.expoIn);

                                        new ATween().tween(loader, {alpha: 0}, 0.575, ()->{
                                            loader.destroy();
                                        }, AEase.expoIn);
                                }
                                trace('Waited long enough, canceling.');
                            });
                        }},
                        {text: 'seperator', func: null},
                        {text: "About Abode", func: ()->{
                            var infoWindow:AWindow = Main.windowManager.makeWindow("tomfuckery!", 0, 0, 400, 200, false, true);
                            var testSprite:ASprite = new ASprite(0, 0).makeGraphic(100, 100, AColor.RED);
                            var testButton:AButton = new AButton("fucking text", new Rectangle(0, 380, 50, 20), ()->{
                                trace("Fuck you, world!");
                            });
                            infoWindow.addContent(testSprite);
                            infoWindow.addContent(testButton);
                        }},
                    ], 200);
                }
            }
        ]);
        add(toolBar);

        var projectScroller:ScrollableArea = new ScrollableArea(Main.pWidth-350, 35);
        add(projectScroller);
        for(i in 0...15) {
            projectScroller.add(new ProjectBox(0, 0+((75+15)*i))); //for testing and getting it ready.
        }
    }
}