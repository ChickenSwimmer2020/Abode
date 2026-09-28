package;

import backend.Locale;
import backend.UPrefs;
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
        ASoundManager.playMusic("assets/sounds/Vectors.wav", UPrefs.mainMenuMuted.value?0.0:0.35);

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
                text: Locale.get("title.menuBar.File"),
                size: new APoint(50, 20),
                onClick: (_:AButton)->{
                    toolBar.openDropdownMenu(0, [
                        {text: '${Locale.get("title.menuBar.File.New")}...', keys:[Keyboard.CONTROL, Keyboard.N], func: (butt:AButton)->{
                            trace("Make new project.");
                        }},
                        {text: '${Locale.get("title.menuBar.File.NewFromTemplate")}...', func: (butt:AButton)->{
                            trace("make new project with template.");
                        }},
                        {text: Locale.get("title.menuBar.File.Open"), func: (butt:AButton)->{
                            trace('Open project from file.');
                        }},
                        {text: '${Locale.get("title.menuBar.File.OpenRecent")} > ', closeOnClick: false, func: (butt:AButton)->{
                            trace('TODO: sub dropdown.');
                        }},
                        {text: Locale.get("title.menuBar.File.Close"), disabled: true, func: (butt:AButton)->{
                            trace('Close current project.');
                        }},
                        {text: Locale.get("title.menuBar.File.CloseAll"), disabled: true, func: (butt:AButton)->{
                            trace('Close all opened projects.');
                        }},
                        {text: Locale.get("title.menuBar.File.Save"), disabled: true, func: (butt:AButton)->{
                            trace('Save current project.');
                        }},
                        {text: '${Locale.get("title.menuBar.File.SaveAs")}...', disabled: true, func: (butt:AButton)->{
                            trace('Save project as a different file.');
                        }},
                        {text: '${Locale.get("title.menuBar.File.SaveAsTemplate")}...', disabled: true, func: (butt:AButton)->{
                            trace('Save project as a new template.');
                        }},
                        {text: Locale.get("title.menuBar.File.Revert"), disabled: true, func: (butt:AButton)->{
                            trace('Unsure what this does. is it like an undo button?');
                        }},
                        {text: 'seperator', func: null},
                        {text: '${Locale.get("title.menuBar.File.Import")} > ', closeOnClick: false, func: (butt:AButton)->{
                            trace('TODO: sub dropdown');
                        }},
                        {text: '${Locale.get("title.menuBar.File.Export")} > ', closeOnClick: false, func: (butt:AButton)->{
                            trace('TODO: sub dropdown');
                        }},
                        {text: 'seperator', func: null},
                        {text: '${Locale.get("title.menuBar.File.ConvertTo")} > ', closeOnClick: false, func: (butt:AButton)->{
                            trace('TODO: sub dropdown');
                        }},
                        {text: 'seperator', func: null},
                        {text: '${Locale.get("title.menuBar.File.DistrobutionSettings")}...', func: (butt:AButton)->{
                            trace('Publish settings but legally distinct');
                        }},
                        {text: Locale.get("title.menuBar.File.Distrobute"), func: (butt:AButton)->{
                            trace('Publish legally distinct');
                        }},
                        {text: 'seperator', func: null},
                        {text: '${Locale.get("title.menuBar.File.HScriptSettings")}...', func: (butt:AButton)->{
                            trace('ActionScript settings');
                        }},
                        #if sys
                            {text: 'seperator', func: null},
                            {text: Locale.get("title.menuBar.File.Exit"), func: (butt:AButton)->{
                                //TODO: check for open projects and prompt user to save before actually closing
                                Sys.exit(0);
                            }},
                        #end
                    ], 200);
                }
            },
            {
                text: Locale.get("title.menuBar.Edit"),
                size: new APoint(50, 20),
                onClick: (_:AButton)->{trace("Edit menu");}
            },
            {
                text: Locale.get("title.menuBar.View"),
                size: new APoint(50, 20),
                onClick: (_:AButton)->{trace("View menu");}
            },
            {
                text: Locale.get("title.menuBar.Insert"),
                size: new APoint(50, 20),
                onClick: (_:AButton)->{trace("Insert menu");}
            },
            {
                text: Locale.get("title.menuBar.Modify"),
                size: new APoint(50, 20),
                onClick: (_:AButton)->{trace("Modify menu");}
            },
            {
                text: Locale.get("title.menuBar.Text"),
                size: new APoint(50, 20),
                onClick: (_:AButton)->{trace("Text menu");}
            },
            {
                text: Locale.get("title.menuBar.Commands"),
                size: new APoint(50, 20),
                onClick: (_:AButton)->{trace("Commands menu");}
            },
            {
                text: Locale.get("title.menuBar.Control"),
                size: new APoint(50, 20),
                onClick: (_:AButton)->{trace("Controls menu");}
            },
            {
                text: Locale.get("title.menuBar.Debug"),
                size: new APoint(50, 20),
                onClick: (_:AButton)->{trace("Debug menu");}
            },
            #if sys
                {
                    text: Locale.get("title.menuBar.Window"),
                    size: new APoint(50, 20),
                    onClick: (_:AButton)->{trace("Window menu");}
                },
            #end
            {
                text: Locale.get("title.menuBar.Help"),
                size: new APoint(50, 20),
                onClick: (_:AButton)->{
                    toolBar.openDropdownMenu(#if(html5)9#else 10#end, [
                        {text: Locale.get("title.menuBar.Help.Help"), func: (butt:AButton)->{trace('Help menu dropdown object 1!');}},
                        {text: '${Locale.get("title.menuBar.Help.ReportBug")}...', func: (butt:AButton)->{trace('Help menu dropdown object 2!');}},
                        {text: 'seperator', func: null},
                        {text: '${Locale.get("title.menuBar.Help.OnlineTutorial")}...', func: (butt:AButton)->{trace('Help menu dropdown object 2!');}},
                        {text: '${Locale.get("title.menuBar.Help.HandsOnTutorial")}  >', closeOnClick: false, func: (butt:AButton)->{trace('TODO: sub dropdown');}},
                        {text: 'seperator', func: null},
                        {text: '${Locale.get("title.menuBar.Help.ManagePlugins")}...', disabled: #if(html5)true#else false#end, func: (butt:AButton)->{trace('TODO: sub dropdown');}},
                        {text: 'seperator', func: null},
                        {text: '${Locale.get("title.menuBar.Help.CheckforUpdates")}...', func: (butt:AButton)->{
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
                                        case -1: Locale.get("error.networking.ConnectionFailed", ["{URL}"=>Network.updateCheckLocation]);
                                        case -4: Locale.get("error.networking.NxDomain");
                                        case -5: Locale.get("error.networking.UnknownError");
                                        default: Locale.get("error.default");
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
                                        text.text = Locale.get("autoupdater.check.runningLatest");
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
                                            var updateWindow:AWindow = Main.windowManager.makeWindow(Locale.get("autoupdater.window.title"), Math.floor(Main.pWidth/2-640/2), Math.floor(Main.pHeight/2-360/2), 640, 360, false, false);
                                        }, AEase.expoIn);

                                        new ATween().tween(loader, {alpha: 0}, 0.575, ()->{
                                            loader.destroy();
                                        }, AEase.expoIn);
                                }
                            });
                        }},
                        {text: 'seperator', func: null},
                        {text: Locale.get("title.menuBar.Help.AboutAbode"), func: (butt:AButton)->{
                            var infoWindow:AWindow = Main.windowManager.makeWindow("If you can see this, a mistake was made.", 0, 0, 400, 200, false, true);
                                var testSprite:ASprite = new ASprite(0, 0).makeGraphic(100, 100, AColor.RED);
                                infoWindow.addContent(testSprite);
                        }},
                    ], 200);
                }
            }
        ]);
        add(toolBar);

        var isMuted:Bool=false;
        var muteButton:AButton = new AButton("[SYM: SOUND]", new Rectangle(toolBar.width-20, 0, 20, 20), (_:AButton)->{
            isMuted=!isMuted;
            _.changeSymbol(isMuted?"MUTE":"SOUND");
            ASoundManager.music.volume = isMuted?0.0:0.35;
            UPrefs.mainMenuMuted.value = isMuted;
        });
        if(UPrefs.mainMenuMuted.value) { //auto mute and shtuff.
            isMuted=true;
            muteButton.changeSymbol("MUTE");
        }
        add(muteButton);

        var projectScroller:ScrollableArea = new ScrollableArea(Main.pWidth-350, 35);
        add(projectScroller);
        for(i in 0...15) {
            var pBox:ProjectBox = new ProjectBox(0, 0+((75+15)*i));
            pBox.loadData(i%2==0?"TestFlashProject":"TestAbodeProjet", i%2==0?"Flash":"AbodeProjectFormat", "Yesterday");
            projectScroller.add(pBox); //for testing and getting it ready.
        }
    }
}