package;

class SplashScreen extends AState {
    var introSprite:ASprite;
    public function new() {
        super();
        try{
            introSprite=new ASprite(0, 0).makeGraphic(100, 100, AColor.TRANSPARENT);
            add(introSprite);

            ATimer.start(1.25, ()->{
                startIntro();
            });
        }catch(e:Exception) Main.traceError(e);
    }

    public function startIntro() {
        try{
            ASoundManager.playSound("assets/sounds/Startup.wav");
            #if sys
                Main.pWidth = 640; //basically, FlxG.width and FlxG.height but interchangable.
                Main.pHeight = 360;
                Lib.application.window.width = 640;
                Lib.application.window.height = 360;
                Lib.application.window.x = Math.floor(Capabilities.screenResolutionX/2-Lib.application.window.width/2);
                Lib.application.window.y = Math.floor(Capabilities.screenResolutionY/2-Lib.application.window.height/2);
            #end
            introSprite.screenCenter();

            //FlashReader.parseFlaFile('IntroAnim.fla');
            for(i in 0...2){
                ATimer.start([0.041, 0.184][i], [
                    ()->drawHaxe(),
                    ()->beginBetterIntro()
                ][i]);
            }
        }catch(e:Exception) Main.traceError(e);
    }
    
    public function beginBetterIntro() {
        try{
            var properSprite:ASprite = new ASprite(-640/2, -360/2, 'assets/images/splash/art.png');
            properSprite.alpha = 0;
            add(properSprite);
            #if html5 properSprite.setGraphicSize(Main.pWidth, Main.pHeight); #end

            new ATween().tween(properSprite, {alpha: 1}, 1.25, null, AEase.quadInOut);
            new ATween().tween(introSprite, {alpha: 0}, 1.25, ()->{
                introSprite.destroy();
                remove(introSprite);

                var nameText:AText = new AText(0, 0, 640, Locale.get("Splash"), 24);
                add(nameText);
                nameText.alignment = CENTER;
                nameText.y = -100;
                new ATween().tween(nameText, {y: 0}, 1.25, AEase.expoOut);

                var loadingIndicator:LoadingIndicator = new LoadingIndicator(300, 200);
                add(loadingIndicator);
                loadingIndicator.screenCenter();
                loadingIndicator.alpha = 0;
                loadingIndicator.y = 360;
                new ATween().tween(loadingIndicator, {alpha: 1, y: (Main.pHeight/2-loadingIndicator.height/2)}, 1.25, AEase.expoOut);


                ATimer.start(5, ()->{ //placeholder for how long preloading will take.
                    ATimer.start(0.75, ()->{
                        final onWindowComplete:Void->Void = ()->{
                            Mouse.hide();
                            #if sys
                                Main.pWidth = 1280;
                                Main.pHeight = 720;
                                Lib.application.window.width = 1280;
                                Lib.application.window.height = 720;
                                Lib.application.window.x = Math.floor(Capabilities.screenResolutionX/2-Lib.application.window.width/2);
                                Lib.application.window.y = Math.floor(Capabilities.screenResolutionY/2-Lib.application.window.height/2);
                            #end
                            Main.StateSystem.switchState(InitState);
                        };
                        try{
                            Mouse.show(); //so you can see what ur doing.
                            if(UPrefs.perferredReference.value.get("NOT SELECTED")==false){
                                onWindowComplete(); //if its been selected before, then we want to skip all this.
                            }else{
                                var referallWindow:AWindow = Main.windowManager.makeWindow(Locale.get("splash.referall.windowTitle"), (640/2-320/2).floor(), (360/2-180/2).floor(), 320, 180, false, false);
                                    for(button in referallWindow.dragBarButtons){
                                        button.disabled = true; //disable the dragbar buttons.
                                        button.visible = false;
                                    }
                                    referallWindow.addContent(new AText(0, 0, referallWindow.width, "We noticed this is your first time launching!\nSince we don't use an account system, you have the choice!\nwhat should we call you?", 12));
                                    var customtextInput:ATextInputBox = cast(referallWindow.addContent(new ATextInputBox(0, 105, 20, 320, null, "{Custom Name Here}", 12, null)), ATextInputBox);
                                    #if(sys)
                                        referallWindow.addContent(new AButton('"${Sys.getEnv(#if(windows)"COMPUTERNAME"#else "HOSTNAME"#end)}"', new Rectangle(0, 145, 106, 20), (_:AButton)->{
                                            trace('User wants to be referred to as: "${Sys.getEnv(#if(windows)"COMPUTERNAME"#else "HOSTNAME"#end)}"!');
                                            UPrefs.perferredReference.value = ["Custom"=>false, "WINUser"=>false, "PCName"=>true, "NOT SELECTED"=>false];
                                            referallWindow.destroy();
                                            onWindowComplete();
                                        }));
                                        referallWindow.addContent(new AButton('"${Sys.getEnv("USERNAME")}"', new Rectangle(106, 145, 106, 20), (_:AButton)->{
                                            UPrefs.perferredReference.value = ["Custom"=>false, "WINUser"=>true, "PCName"=>false, "NOT SELECTED"=>false];
                                            referallWindow.destroy();
                                            onWindowComplete();
                                        }));
                                    #end
                                    referallWindow.addContent(new AButton("Custom", new Rectangle(#if(sys)214#else 0#end, 145,  #if(sys)106#else 180#end, 20), (_:AButton)->{
                                        UPrefs.perferredReference.value = ["Custom"=>true, "WINUser"=>false, "PCName"=>false, "NOT SELECTED"=>false];
                                        UPrefs.customReferenceName.value = customtextInput.text;
                                        referallWindow.destroy();
                                        onWindowComplete();
                                    }));
                            }
                        }catch(e:Exception) Main.traceError(e);
                    });
                });
            }, AEase.quadInOut);
        }catch(e:Exception) Main.traceError(e);
    }

    

	function drawHaxe() {
        try{
            introSprite.graphics.beginFill(0x00b922);
            introSprite.graphics.moveTo(0, -37);
            introSprite.graphics.lineTo(1, -37);
            introSprite.graphics.lineTo(37, 0);
            introSprite.graphics.lineTo(37, 1);
            introSprite.graphics.lineTo(1, 37);
            introSprite.graphics.lineTo(0, 37);
            introSprite.graphics.lineTo(-37, 1);
            introSprite.graphics.lineTo(-37, 0);
            introSprite.graphics.lineTo(0, -37);
            introSprite.graphics.endFill();
        }catch(e:Exception) Main.traceError(e);
	}
}