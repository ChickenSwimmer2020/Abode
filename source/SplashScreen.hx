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
                        #if sys
                            Main.pWidth = 1280;
                            Main.pHeight = 720;
                            Lib.application.window.width = 1280;
                            Lib.application.window.height = 720;
                            Lib.application.window.x = Math.floor(Capabilities.screenResolutionX/2-Lib.application.window.width/2);
                            Lib.application.window.y = Math.floor(Capabilities.screenResolutionY/2-Lib.application.window.height/2);
                        #end
                        Main.StateSystem.switchState(InitState);
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