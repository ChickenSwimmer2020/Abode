package;
#if debug 
    import backend.utils.DebugDisplay;
    import backend.utils.DebugDisplay.Heartbeat;
#end

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
    public static var StateSystem:StateSystemInit = new StateSystemInit(null); //defaults to splashscreen since thats literally the only thing it does on init
    public function new() {
        super();
        openfl.Lib.current.stage.addEventListener(openfl.events.UncaughtErrorEvent.UNCAUGHT_ERROR, function(e:openfl.events.UncaughtErrorEvent) {
            trace('UNCAUGHT ERROR: ' + e.error);
            #if sys
            Sys.println('UNCAUGHT ERROR: ' + e.error);
            #end
            e.preventDefault();
            e.stopImmediatePropagation();
        });
        Tween.globalParent = this; //so that new Tween() will auto-destroy and not cause memory leaks.
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

        #if debug
            var stats = new DebugDisplay();
            stage.addChild(new Heartbeat());
            stage.addChild(stats); // add to stage directly so it's always on top
            stats.x = 10;
            stats.y = 10;
        #end

        Mouse.hide();
        ATimer.start(0.5, ()->{
            new Tween().tween(Application.current.window, {opacity: 1.0}, 1.25, null, AEase.expoOut);
        });
    }
}