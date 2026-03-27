package backend.utils;

import openfl.events.TimerEvent;
import openfl.utils.Timer;

class ATimer {
    /**
     * easily start a new timer, much like how Flixel does it. because timers in openfl are FUCKING. STUPID.
     * @param time how long to wait
     * @param onComplete what to do when done.
     */
    public static function start(time:Float, onComplete:Void->Void) {
        var timer:Timer = new Timer(time * 1000, 1);
        var handler:TimerEvent->Void = null;
        handler = (_)->{
            timer.removeEventListener(TimerEvent.TIMER_COMPLETE, handler);
            timer.stop();
            timer = null;
            onComplete();
        };
        timer.addEventListener(TimerEvent.TIMER_COMPLETE, handler);
        timer.start();
    }
}