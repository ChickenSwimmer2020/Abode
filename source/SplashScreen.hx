package;

import flixel.util.FlxColor;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.system.FlxAssets;
import flixel.FlxG;
import openfl.display.Sprite;
import lime.app.Application;
import flixel.math.FlxPoint;
import flixel.FlxSprite;
import flixel.FlxState;

using flixel.util.FlxSpriteUtil;

class SplashScreen extends FlxState {
    var introSprite:Sprite = new Sprite();
    public function new() {
        super();
        Application.current.window.stage.addChild(introSprite);
        new FlxTimer().start(1.25, (_)->{
            startIntro();
            _.destroy();
        });
    }

    public function startIntro() {
        introSprite.x = (640 / 2);
		introSprite.y = (360 / 2) - 20 * FlxG.game.scaleY;
        FlxG.sound.load(FlxAssets.getSoundAddExtension("flixel/sounds/flixel")).play();

		for(i in 0...6){
            new FlxTimer().start([0.041, 0.184, 0.334, 0.495, 0.636, 1.1253][i], [
                (_)->{
                    drawGreen();
                    _.destroy();
                },
                (_)->{
                    drawYellow();
                    _.destroy();
                },
                (_)->{
                    drawRed();
                    _.destroy();
                },
                (_)->{
                    drawBlue();
                    _.destroy();
                },
                (_)->{
                    drawLightBlue();
                    _.destroy();
                },
                (_)->{
                    beginBetterIntro();
                    _.destroy();
                }
            ][i]);
        }
    }
    
    public function beginBetterIntro() {
        var properSprite:FlxSprite = new FlxSprite(0, 0).loadGraphic('assets/images/splash/art.png');
        properSprite.alpha = 0;
        add(properSprite);
        properSprite.setGraphicSize(FlxG.width, FlxG.height);
        properSprite.updateHitbox();
        FlxTween.tween(properSprite, {alpha: 1}, 1.25, {ease: FlxEase.quadInOut});
        FlxTween.tween(introSprite, {alpha: 0}, 1.25, {ease: FlxEase.quadInOut, onComplete: (_)->{
            Application.current.window.stage.removeChild(introSprite);

            var loadingIndicator:FlxSprite = new FlxSprite(0, 0).loadGraphic("assets/images/loadingIndicator.png", true, 82, 81);
            loadingIndicator.animation.add("1", [for(i in 0...20) i], 24, true);
            loadingIndicator.animation.play("1");
            add(loadingIndicator);


            //new FlxTimer().start(5, (_)->{ //placeholder for how long preloading will take.
            //    FlxTween.tween(Application.current.window, {opacity: 0}, 1.25, {ease: FlxEase.quadInOut});
            //});
        }});
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