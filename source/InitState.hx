package;

import backend.utils.ATimer;
import openfl.display.BitmapData;
import rendering.BlurredSprite;
import openfl.filters.BlurFilter;
import openfl.filters.ShaderFilter;
import lime.graphics.Image;
import backend.ASprite;
import backend.utils.State;

class InitState extends State {
    var wallpaperBackground:ASprite;
    public function new() {
        super();

        //TODO: make dynamic wallpaper loading work properly without crashing the program.
        wallpaperBackground = new ASprite(0, 0).loadGraphic('assets/images/FbutteRAUtah.png'/*ASprite.getDesktopWallpaper(1280, 720)*/); //TODO: blur shader
        add(wallpaperBackground);

        ATimer.start(0.25, ()->{
            var testBlurSprite:BlurredSprite = new BlurredSprite(1280, 720, 0x000000, 0, BitmapData.fromFile('assets/images/FbutteRAUtah.png'), 4, 2);
            add(testBlurSprite);
            var secondaryTestBlurSprite:BlurredSprite = new BlurredSprite(500, Main.pHeight, 0x000000, 0.25, BitmapData.fromFile('assets/images/FbutteRAUtah.png'), 16, 2);
            secondaryTestBlurSprite.x = Main.pWidth-secondaryTestBlurSprite.width;
            add(secondaryTestBlurSprite);
        });
    }
}