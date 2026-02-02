package;

import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import openfl.system.Capabilities;
import lime.app.Application;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite {
    public function new() {
        super();
        addChild(new FlxGame(0, 0, SplashScreen, 60, 60, false, false));
        Application.current.window.borderless = true;
        Application.current.window.opacity = 0;
        Application.current.window.minimized = false;
        Application.current.window.width = 640;
        Application.current.window.height = 360;
        Application.current.window.x = Math.floor(Capabilities.screenResolutionX/2 - Application.current.window.width/2);
        Application.current.window.y = Math.floor(Capabilities.screenResolutionY/2 - Application.current.window.height/2);
        FlxG.mouse.cursor.visible = false;
        new FlxTimer().start(0.5, (_)->{
            //center window for the cool intro anim that i want

            FlxTween.tween(Application.current.window, {opacity: 1}, 1.25, {ease: FlxEase.expoOut});

            _.destroy();
        });
    }
}