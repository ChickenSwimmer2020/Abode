package;

import backend.flashfile.FLAParser.FlashReader;
import backend.LoadingIndicator;
import openfl.display.BitmapData;
import openfl.system.Capabilities;
import lime.app.Application;
import backend.utils.ATween.AEase;
import backend.ASprite;
import backend.utils.ATimer;
import backend.utils.State;
import backend.ASprite as Sprite;

class SplashScreen extends State {
    var introSprite:ASprite;
    public function new() {
        super();
        introSprite=new ASprite(0, 0).makeGraphic(100, 100, 0xFFFF0000);
        add(introSprite);

        ATimer.start(1.25, ()->{
            startIntro();
        });
    }

    public function startIntro() {
        introSprite.x = (640 / 2);
		introSprite.y = (360 / 2); //no clue how to get scaleY :/
        //FlxG.sound.load(FlxAssets.getSoundAddExtension("flixel/sounds/flixel")).play();

        trace(FlashReader.parseFlaFile('IntroAnim.fla'));
		for(i in 0...6){
            ATimer.start([0.041, 0.184, 0.334, 0.495, 0.636, 1.1253][i], [
                ()->{
                    drawGreen();
                },
                ()->{
                    drawYellow();
                },
                ()->{
                    drawRed();
                },
                ()->{
                    drawBlue();
                },
                ()->{
                    drawLightBlue();
                },
                ()->{
                    beginBetterIntro();
                }
            ][i]);
        }
    }
    
    public function beginBetterIntro() {
        var properSprite:ASprite = new ASprite(-640/2, -360/2, BitmapData.fromFile('assets/images/splash/art.png'));
        properSprite.alpha = 0;
        add(properSprite);
        Main.tween.tween(properSprite, {alpha: 1}, 1.25, null, AEase.quadInOut);
        Main.tween.tween(introSprite, {alpha: 0}, 1.25, ()->{
            remove(introSprite);

            var loadingIndicator:LoadingIndicator = new LoadingIndicator(300, 200);
            add(loadingIndicator);


            ATimer.start(5, ()->{ //placeholder for how long preloading will take.
                Main.tween.tween(Application.current.window, {opacity: 0}, 1.25, ()->{
                    Application.current.window.borderless = false;
                    Application.current.window.opacity = 1;
                    Application.current.window.width = 1280;
                    Application.current.window.height = 720;
                    Application.current.window.x = Math.floor(Capabilities.screenResolutionX/2 - Application.current.window.width/2);
                    Application.current.window.y = Math.floor(Capabilities.screenResolutionY/2 - Application.current.window.height/2);
                    Main.StateSystem.switchState(InitState);
                }, AEase.quadInOut);
            });
        }, AEase.quadInOut);
    }

    

	function drawGreen() {
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
    
    function drawYellow() {
    	introSprite.graphics.beginFill(0xffc132);
    	introSprite.graphics.moveTo(-50, -50);
    	introSprite.graphics.lineTo(-25, -50);
    	introSprite.graphics.lineTo(0, -37);
    	introSprite.graphics.lineTo(-37, 0);
    	introSprite.graphics.lineTo(-50, -25);
    	introSprite.graphics.lineTo(-50, -50);
    	introSprite.graphics.endFill();
    }
    
    function drawRed() {
    	introSprite.graphics.beginFill(0xf5274e);
    	introSprite.graphics.moveTo(50, -50);
    	introSprite.graphics.lineTo(25, -50);
    	introSprite.graphics.lineTo(1, -37);
    	introSprite.graphics.lineTo(37, 0);
    	introSprite.graphics.lineTo(50, -25);
    	introSprite.graphics.lineTo(50, -50);
    	introSprite.graphics.endFill();
    }
    
    function drawBlue() {
    	introSprite.graphics.beginFill(0x3641ff);
    	introSprite.graphics.moveTo(-50, 50);
    	introSprite.graphics.lineTo(-25, 50);
    	introSprite.graphics.lineTo(0, 37);
    	introSprite.graphics.lineTo(-37, 1);
    	introSprite.graphics.lineTo(-50, 25);
    	introSprite.graphics.lineTo(-50, 50);
    	introSprite.graphics.endFill();
    }
    
    function drawLightBlue() {
    	introSprite.graphics.beginFill(0x04cdfb);
    	introSprite.graphics.moveTo(50, 50);
    	introSprite.graphics.lineTo(25, 50);
    	introSprite.graphics.lineTo(1, 37);
    	introSprite.graphics.lineTo(37, 1);
    	introSprite.graphics.lineTo(50, 25);
    	introSprite.graphics.lineTo(50, 50);
    	introSprite.graphics.endFill();
    }
}