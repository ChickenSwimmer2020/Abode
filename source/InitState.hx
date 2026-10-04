package;

class InitState extends AState {
    var wallpaperBackground:ASprite;
    var toolBar:AMenuBar;
    var welcomeText:AText;
    public static var appliedDarkenOnlyOnce:Bool = false;
    public function new() {
        super();
        try{
            //overrides for normal application actions with keys.
            Main.addKeyPressed("toggleFullscreenWithF11", Keyboard.F11, false, (_:KeyboardEvent)->{
                Application.current.window.fullscreen = !Application.current.window.fullscreen;
            });
            //we have to do these here so they dont start on the splash screen.
            ASoundManager.playMusic("assets/sounds/Vectors.wav", UPrefs.mainMenuMuted.value?0.0:0.35);

            Mouse.show();
            wallpaperBackground = new ASprite(0, 0).loadGraphic(Main.desktopbackgroundImage, true);
            add(wallpaperBackground);
            #if html5 wallpaperBackground.setGraphicSize(Main.pWidth, Main.pHeight); #end
            
            if(!appliedDarkenOnlyOnce){ //holy shit, didnt realize there was a bug here!
                //projects list darken.
                wallpaperBackground.applyLocalFilter(
                    new Rectangle(wallpaperBackground.width-wallpaperBackground.width/2+150, 0, wallpaperBackground.width/3+200, wallpaperBackground.height),
                    new BlurFilter(32, 8, 3),
                    {colorTransform: AColor.MAINMENU_PROJECTSLIST_DARKEN, offsets: new Rectangle(50, -100, 200, 200)}
                );

                //top left darken area for the presets
                wallpaperBackground.applyLocalFilter(
                    new Rectangle(0, 0, 600, 260),
                    new BlurFilter(32, 32, 3),
                    {colorTransform: AColor.MAINMENU_PROJECTSLIST_DARKEN}
                );
                appliedDarkenOnlyOnce = true;
            }
            final totalLaunchMessages:Int = 4;
            welcomeText = new AText(0, 20, 600, Locale.get("title.welcomeMSG", ["{USER}"=>"[USER]", "{MSGOFLAUNCH}"=>Locale.get('title.launchMSG${Std.string(AMath.random(0, totalLaunchMessages))}')]), 12);
            add(welcomeText);
            welcomeText.textColor = AColor.WHITE;
            add(new AButton(Locale.get("title.newProject"), new Rectangle(5, 235, 80, 20), (_:AButton)->{
                trace("TODO: new Project window.");
            }));
            add(new AButton(Locale.get("title.loadProject"), new Rectangle(90, 235, 80, 20), (_:AButton)->{
                trace("TODO: Open project file popup");
            }));


            for(i in 0...6) {
                var button = new AButton(Locale.get('title.presetButton$i'), new Rectangle(7+((82*i)+(14*i)), 40, 82, 140), [
                    (one)->{},
                    (two)->{},
                    (three)->{},
                    (four)->{},
                    (five)->{},
                    (six)->{},
                ][i]);
                add(button);
            }

            //TODO: first time launch popup asking if you want to be called by a custom name, pc name, or windows account name.

            //presets, that show on the main menu
            // Full HD
            // Android 16:9
            // Banner
            // iPad 3-4 Gen
            // Canvas
            // More Presets (opens new Project window.)

            //presets (that show other than the more presets button, which just opens teh new project window.)
            // [ICON] TITLE (WIDTHxHEIGHT)
            /*Character Animation tab*/
            // [Video] HD (1280x720)
            // [Video] Full HD (1920x1080)
            // [Video] 4k (3840x2160)
            // [Video] Standard (640x480)
            /*Social tab*/
            // [FaceBook] Small (256x144)
            // [FaceBook] Large (3840x2160)
            // [FaceBook] Landscape (600x315)
            // [FaceBook] Square (600x600)
            // [FaceBook] Vertical (600x750)
            // [Twitter] In-stream Photo (440x220)
            // [Twitter] Profile Photo (400x400)
            // [Twitter] Header Photo (1500x500)
            // Includes (HD, Full HD, 4K, Standard) from Character Animations, but with YT icon
            /*Game tab*/
            // [Browser] Low (640x480)
            // [Browser] Medium (800x600)
            // [Browser] High (860x640)
            // [Browser] Very High (1024x768)
            // [Mobile] iPhone-5 (1136x640)
            // [Mobile] iPhone-4 (960x640)
            // [Mobile] iPhone 1-3 (480x320)
            // [Mobile] Android 16:9 (1280x720)
            // [Mobile] Android 16:10 (1680x1050)
            // [Mobile] Android 5:3 (1280x768)
            // [Mobile] Android 3:2 (960x640)
            // [Mobile] Android 4:3 (1024x768)
            // [Tablet] iPad 3-4 Gen (2048x1536)
            // [Tablet] iPad 1-3 Gen (1024x768)
            /*Education tab*/ //Ew, education.
            // |LITERALLY, the same as the games tab.|
            // [Video] Standard Video (1280x720)
            /*Ads Tab*/ //NO.
            /*Web Tab*/
            // the same as the game tab.
            /*Advanced Tab*/ //oh boy here we go.
            /**SubTab: PLATFORMS**/
            // HTML5 Canvas
            // HScript (version)
            // Air for Desktop //! not happening.
            // Air for IOS //! not happening.
            // Air for Android //! not happening.
            /**SubTab: BETA PLATFORMS**/
            // VR Panorama //? maybe.
            // VR 360 //? maybe.
            // WebGL glTF Extended //? maybe.
            // WebGL glTF Standard //? maybe.
            /**SubTab: SCRIPTS**/
            // HScript Class
            // HScript Interface
            // HScript File
            // HScript plugin preset.

                
            toolBar = new AMenuBar(TOP, [
                {
                    type: ABUTTON,
                    text: Locale.get("title.menuBar.File"),
                    size: new APoint(50, 20),
                    onClick: (_:AButton)->{
                        ADropdown.openDropdownMenu(_, false, [
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
                    type: ABUTTON,
                    text: Locale.get("title.menuBar.Edit"),
                    size: new APoint(50, 20),
                    onClick: (_:AButton)->{
                        ADropdown.openDropdownMenu(_, [
                            {text: '${Locale.get("title.menuBar.Edit.Undo")}', keys:[], disabled: true, func: (butt:AButton)->{
                                trace("Undo last edit (in-project)");
                            }},
                            {text: '${Locale.get("title.menuBar.Edit.Redo")}', keys:[], disabled: true, func: (butt:AButton)->{
                                trace("Undo the last undo (in-project");
                            }},
                            {text: 'seperator', func: null},
                            {text: '${Locale.get("title.menuBar.Edit.Cut")}', keys:[], disabled: true, func: (butt:AButton)->{
                                trace("Cut (in-project)");
                            }},
                            {text: '${Locale.get("title.menuBar.Edit.Copy")}', keys:[], disabled: true, func: (butt:AButton)->{
                                trace("Copy (in-project)");
                            }},
                            {text: '${Locale.get("title.menuBar.Edit.PasteCenter")}', keys:[], disabled: true, func: (butt:AButton)->{
                                trace("Paste in Center (in-project)");
                            }},
                            {text: '${Locale.get("title.menuBar.Edit.PastePlace")}', keys:[], disabled: true, func: (butt:AButton)->{
                                trace("Paste in Place (in-project)");
                            }},
                            {text: '${Locale.get("title.menuBar.Edit.Clear")}', keys:[], disabled: true, func: (butt:AButton)->{
                                trace("Clear (in-project)");
                            }},
                            {text: 'seperator', func: null},
                            {text: '${Locale.get("title.menuBar.Edit.Duplicate")}', keys:[], disabled: true, func: (butt:AButton)->{
                                trace("Duplicate (in-project)");
                            }},
                            {text: '${Locale.get("title.menuBar.Edit.SelectAll")}', keys:[], disabled: true, func: (butt:AButton)->{
                                trace("Select All (in-project)");
                            }},
                            {text: '${Locale.get("title.menuBar.Edit.DeselectAll")}', keys:[], disabled: true, func: (butt:AButton)->{
                                trace("Deselect All (in-project)");
                            }},
                            {text: '${Locale.get("title.menuBar.Edit.InvertSelection")}', keys:[], disabled: true, func: (butt:AButton)->{
                                trace("Invert Selection (in-project)");
                            }},
                            {text: 'seperator', func: null},
                            {text: '${Locale.get("title.menuBar.Edit.FindandReplace")}', keys:[], disabled: true, func: (butt:AButton)->{
                                trace("Find and Replace (in-project)");
                            }},
                            {text: '${Locale.get("title.menuBar.Edit.FindNext")}', keys:[], disabled: true, func: (butt:AButton)->{
                                trace("Find Next (in-project)");
                            }},
                            {text: 'seperator', func: null},
                            {text: '${Locale.get("title.menuBar.Edit.TimeLine")} > ', keys:[], closeOnClick: false, func: (butt:AButton)->{
                                ADropdown.openSubDropdownMenu(butt, [
                                    {text: '${Locale.get("title.menuBar.Edit.TimeLine.RemoveFrames")}', keys:[], disabled: true, func: (butt:AButton)->{
                                        trace("Remove Frames Timeline (in-project)");
                                    }},
                                    {text: 'seperator', func: null},
                                    {text: '${Locale.get("title.menuBar.Edit.TimeLine.CutFrames")}', keys:[], disabled: true, func: (butt:AButton)->{
                                        trace("Cut Frames Timeline (in-project)");
                                    }},
                                    {text: '${Locale.get("title.menuBar.Edit.TimeLine.CopyFrames")}', keys:[], disabled: true, func: (butt:AButton)->{
                                        trace("Copy Frames Timeline (in-project)");
                                    }},
                                    {text: '${Locale.get("title.menuBar.Edit.TimeLine.PasteFrames")}', keys:[], disabled: true, func: (butt:AButton)->{
                                        trace("Paste Frames Timeline (in-project)");
                                    }},
                                    {text: '${Locale.get("title.menuBar.Edit.TimeLine.PasteOverwriteFrames")}', keys:[], disabled: true, func: (butt:AButton)->{
                                        trace("Paste and Overwrite Frames Timeline (in-project)");
                                    }},
                                    {text: '${Locale.get("title.menuBar.Edit.TimeLine.ClearFrames")}', keys:[], disabled: true, func: (butt:AButton)->{
                                        trace("Clear Frames Timeline (in-project)");
                                    }},
                                    {text: '${Locale.get("title.menuBar.Edit.TimeLine.SelectAllFrames")}', keys:[], disabled: true, func: (butt:AButton)->{
                                        trace("Select All Frames Timeline (in-project)");
                                    }},
                                    {text: 'seperator', func: null},
                                    {text: '${Locale.get("title.menuBar.Edit.TimeLine.CutLayers")}', keys:[], disabled: true, func: (butt:AButton)->{
                                        trace("Cut Layers Timeline (in-project)");
                                    }},
                                    {text: '${Locale.get("title.menuBar.Edit.TimeLine.CopyLayers")}', keys:[], disabled: true, func: (butt:AButton)->{
                                        trace("Copy Layers Timeline (in-project)");
                                    }},
                                    {text: '${Locale.get("title.menuBar.Edit.TimeLine.PasteLayers")}', keys:[], disabled: true, func: (butt:AButton)->{
                                        trace("Paste Layers Timeline (in-project)");
                                    }},
                                    {text: '${Locale.get("title.menuBar.Edit.TimeLine.DuplicateLayers")}', keys:[], disabled: true, func: (butt:AButton)->{
                                        trace("Duplicate Layers Timeline (in-project)");
                                    }},
                                    {text: '${Locale.get("title.menuBar.Edit.TimeLine.MergeLayers")}', keys:[], disabled: true, func: (butt:AButton)->{
                                        trace("Merge Layers Timeline (in-project)");
                                    }},
                                    {text: 'seperator', func: null},
                                    {text: '${Locale.get("title.menuBar.Edit.TimeLine.CopyMotion")}', keys:[], disabled: true, func: (butt:AButton)->{
                                        trace("Copy Motion Timeline (in-project)");
                                    }},
                                    {text: '${Locale.get("title.menuBar.Edit.TimeLine.PasteMotion")}', keys:[], disabled: true, func: (butt:AButton)->{
                                        trace("Paste Motion Timeline (in-project)");
                                    }},
                                    {text: '${Locale.get("title.menuBar.Edit.TimeLine.PasteMotionSpecial")}...', keys:[], disabled: true, func: (butt:AButton)->{
                                        trace("Paste Motion Special Timeline (in-project)");
                                    }},
                                ]);
                            }},
                            {text: 'seperator', func: null},
                            {text: '${Locale.get("title.menuBar.Edit.EditObjects")}', keys:[], disabled: true, func: (butt:AButton)->{
                                trace("Edit Objects(Symbols) (in-project)");
                            }},
                            {text: '${Locale.get("title.menuBar.Edit.EditSelected")}', keys:[], disabled: true, func: (butt:AButton)->{
                                trace("Edit Selected (in-project)");
                            }},
                            {text: '${Locale.get("title.menuBar.Edit.EditRig")}', keys:[], disabled: true, func: (butt:AButton)->{
                                trace("Edit Rig (in-project)");
                            }},
                            {text: 'seperator', func: null},
                            {text: '${Locale.get("title.menuBar.Edit.Preferences")} > ', keys:[], func: (butt:AButton)->{
                                trace("Edit Rig (in-project)");
                            }},
                            {text: '${Locale.get("title.menuBar.Edit.FontMapping")}...', keys:[], func: (butt:AButton)->{
                                trace("Font Mappings");
                            }},
                            {text: '${Locale.get("title.menuBar.Edit.KeyboardShortcuts")}', keys:[], func: (butt:AButton)->{
                                trace("Keyboard Shortcuts (in-project)");
                            }},
                        ], 200);
                    }
                },
                {
                    type: ABUTTON,
                    text: Locale.get("title.menuBar.View"),
                    size: new APoint(50, 20),
                    onClick: (_:AButton)->{trace("View menu");}
                },
                {
                    type: ABUTTON,
                    text: Locale.get("title.menuBar.Insert"),
                    size: new APoint(50, 20),
                    onClick: (_:AButton)->{trace("Insert menu");}
                },
                {
                    type: ABUTTON,
                    text: Locale.get("title.menuBar.Modify"),
                    size: new APoint(50, 20),
                    onClick: (_:AButton)->{trace("Modify menu");}
                },
                {
                    type: ABUTTON,
                    text: Locale.get("title.menuBar.Text"),
                    size: new APoint(50, 20),
                    onClick: (_:AButton)->{trace("Text menu");}
                },
                {
                    type: ABUTTON,
                    text: Locale.get("title.menuBar.Commands"),
                    size: new APoint(50, 20),
                    onClick: (_:AButton)->{trace("Commands menu");}
                },
                {
                    type: ABUTTON,
                    text: Locale.get("title.menuBar.Control"),
                    size: new APoint(50, 20),
                    onClick: (_:AButton)->{trace("Controls menu");}
                },
                {
                    type: ABUTTON,
                    text: Locale.get("title.menuBar.Debug"),
                    size: new APoint(50, 20),
                    onClick: (_:AButton)->{
                        /*8*/
                        ADropdown.openDropdownMenu(_, false, [

                            #if debug //debug exclusive options, like the UI debugger system.
                                {text: 'seperator', func: null},
                                {text: '${Locale.get("title.menuBar.Debug.UIDebugger")}', func: (butt:AButton)->{
                                    Main.StateSystem.switchState(UIDebugger);
                                }},
                                {text: '${Locale.get("title.menuBar.Debug.SymbolEditor")}', func: (butt:AButton)->{
                                    Main.StateSystem.switchState(SymbolEditor);
                                }}
                            #end
                        ]);
                    }
                },
                #if sys
                    {
                        type: ABUTTON,
                        text: Locale.get("title.menuBar.Window"),
                        size: new APoint(50, 20),
                        onClick: (_:AButton)->{trace("Window menu");}
                    },
                #end
                {
                    type: ABUTTON,
                    text: Locale.get("title.menuBar.Help"),
                    size: new APoint(50, 20),
                    onClick: (_:AButton)->{
                        ADropdown.openDropdownMenu(_, false, [
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
                                var infoWindow:AWindow = Main.windowManager.makeWindow("If you can see this, a mistake was made.", 0, 0, 320, 240, true, false);
                                infoWindow.screenCenter();
                                var onWindowClick:MouseEvent->Void;
                                onWindowClick = (_:MouseEvent)->{
                                    infoWindow.removeEventListener(MouseEvent.CLICK, onWindowClick);
                                    infoWindow.destroy();
                                };
                                infoWindow.addEventListener(MouseEvent.CLICK, onWindowClick);
                                //Main.StateSystem.state.canInteract=false; //TODO: make this stupid thing work properly. 

                                    var logo:ASprite = new ASprite(0, 0).loadGraphic("assets/images/ICON48.png");
                                    var name:AText = new AText(0+logo.width, 5, 100, "Abode V{MAJORVER}.{MIDVER}.{MINORVER}", 12);


                                    infoWindow.addContent(logo);
                                    infoWindow.addContent(name);

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
        }catch(e:Exception) Main.traceError(e);
    }
}