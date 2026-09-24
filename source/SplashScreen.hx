package;

import openfl.Lib;

class SplashScreen extends AState {
    var introSprite:ASprite;
    public function new() {
        super();
        introSprite=new ASprite(0, 0).makeGraphic(100, 100, 0x000000, 0);
        add(introSprite);

        ATimer.start(1.25, ()->{
            startIntro();
        });
    }

    public function startIntro() {
        Main.pWidth = 640; //basically, FlxG.width and FlxG.height but interchangable.
        Main.pHeight = 360;
        Lib.application.window.width = 640;
        Lib.application.window.height = 360;
        introSprite.x = (640 / 2)-introSprite.scaleX/2;
		introSprite.y = (360 / 2)-introSprite.scaleY/2;
        //FlxG.sound.load(FlxAssets.getSoundAddExtension("flixel/sounds/flixel")).play();

        //FlashReader.parseFlaFile('IntroAnim.fla');
		for(i in 0...2){
            ATimer.start([0.041, 0.184][i], [
                ()->drawHaxe(),
                ()->beginBetterIntro()
            ][i]);
        }
    }
    
    public function beginBetterIntro() {
        var properSprite:ASprite = new ASprite(-640/2, -360/2, BitmapData.fromFile('assets/images/splash/art.png'));
        properSprite.alpha = 0;
        add(properSprite);
        new ATween().tween(properSprite, {alpha: 1}, 1.25, null, AEase.quadInOut);
        new ATween().tween(introSprite, {alpha: 0}, 1.25, ()->{
            introSprite.destroy();
            remove(introSprite);

            var loadingIndicator:LoadingIndicator = new LoadingIndicator(300, 200);
            add(loadingIndicator);


            ATimer.start(5, ()->{ //placeholder for how long preloading will take.
                ATimer.start(0.75, ()->{
                    Main.pWidth = 1280;
                    Main.pHeight = 720;
                    Lib.application.window.width = 1280;
                    Lib.application.window.height = 720;
                    Main.StateSystem.switchState(InitState);
                });
            });
        }, AEase.quadInOut);
    }

    

	function drawHaxe() {
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
	}
}