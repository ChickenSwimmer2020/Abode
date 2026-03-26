package;

import openfl.ui.Mouse;
import backend.utils.ATween.AEase;
import backend.utils.ATween.Tween;
import backend.utils.InitalState.StateSystemInit;
import openfl.events.Event;
import backend.utils.ATimer;
import sys.io.File;
import lime.graphics.Image;
import openfl.system.Capabilities;
import lime.app.Application;

class Main extends openfl.display.Sprite {
    public static var pWidth:Int=0;
    public static var pHeight:Int=0;

    //CONTROLLERS (very weird system, but it works \_シ_/)
    public static var tween = new Tween();
    public static var StateSystem:StateSystemInit = new StateSystemInit(null); //defaults to splashscreen since thats literally the only thing it does on init
    public function new() {
        super();
        pWidth = Application.current.window.width;
        pHeight = Application.current.window.height;
        

        addChild(StateSystem);
        StateSystem.switchState(SplashScreen); //wait fuck this might work!
        Application.current.window.borderless = true;
        Application.current.window.opacity = 0;
        Application.current.window.minimized = false;
        Application.current.window.width = 640;
        Application.current.window.height = 360;
        Application.current.window.x = Math.floor(Capabilities.screenResolutionX/2 - Application.current.window.width/2);
        Application.current.window.y = Math.floor(Capabilities.screenResolutionY/2 - Application.current.window.height/2);

        Mouse.hide();
        ATimer.start(0.5, ()->{
            tween.tween(Application.current.window, {opacity: 1.0}, 1.25, null, AEase.expoOut);
        });
    }
}