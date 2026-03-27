package backend.utils;

import openfl.display.Sprite;
import openfl.events.Event;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;

class DebugDisplay extends Sprite {
    private var label:TextField;
    private var frameCount:Int = 0;
    private var fps:Float = 0;
    private var fpsTimer:Float = 0;
    private var lastTime:Int = 0;

    public function new() {
        super();

        // background
        graphics.beginFill(0x000000, 0.6);
        graphics.drawRect(0, 0, 200, 80);
        graphics.endFill();

        // text field
        label = new TextField();
        label.defaultTextFormat = new TextFormat("_typewriter", 11, 0x00FF00);
        label.width = 200;
        label.height = 80;
        label.selectable = false;
        label.mouseEnabled = false;
        addChild(label);

        lastTime = openfl.Lib.getTimer();
        addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

    private function onEnterFrame(e:Event):Void {
        var now = openfl.Lib.getTimer();
        var dt = (now - lastTime) / 1000.0;
        lastTime = now;

        frameCount++;
        fpsTimer += dt;

        if (fpsTimer >= 0.5) { // update every 0.5 seconds
            fps = frameCount / fpsTimer;
            frameCount = 0;
            fpsTimer = 0;
        }

        var mem = System.totalMemory / 1024 / 1024; // bytes to MB

        label.text = 
            'FPS:    ${Math.round(fps)}\n' +
            'MEM:    ${Math.round(mem * 10) / 10} MB\n' +
            'STAGE:  ${stage != null ? stage.numChildren : 0} children\n' +
            'OBJ:    ${numChildren} children';
    }

    public function destroy():Void {
        removeEventListener(Event.ENTER_FRAME, onEnterFrame);
        if (parent != null) parent.removeChild(this);
    }
}

//for testing to make sure im not going fucking insane.
class Heartbeat extends Sprite {
    private var tick:Int = 0;
    
    public function new() {
        super();
        addEventListener(Event.ENTER_FRAME, onEnterFrame);
    }

    private var lastChildCount:Int = 0;
    private function onEnterFrame(e:Event):Void {
        tick++;
        // prints every 60 frames so you can see its still alive
        if (tick % 60 == 0) {
            trace('heartbeat tick: $tick | time: ${openfl.Lib.getTimer()}ms');
            var count = stage.numChildren;
            if (count != lastChildCount) {
                trace('!!! stage children changed: $lastChildCount -> $count');
                lastChildCount = count;
                for (i in 0...count)
                    trace('  child $i: ${stage.getChildAt(i)}');
            }
        }
    }
}

//crash timings (3/27/2026)
/**
 * 7987ms
 * 
 */
