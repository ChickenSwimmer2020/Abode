package;

import backend.utils.ATimer;
import openfl.display.BitmapData;
import openfl.filters.BlurFilter;
import openfl.filters.ShaderFilter;
import lime.graphics.Image;
import backend.ASprite;
import backend.utils.State;

class InitState extends State {
    var wallpaperBackground:ASprite;
    public function new() {
        super();

        var wallpaperBG:BitmapData = BitmapData.fromFile('assets/images/FbutteRAUtah.png'); //TODO: make user desktop image loading work.
        wallpaperBackground = new ASprite(0, 0).loadGraphic(wallpaperBG/*ASprite.getDesktopWallpaper(1280, 720)*/);
        add(wallpaperBackground);


        var dest = new openfl.geom.Point(50, 50); // where to write the result

        wallpaperBG.applyFilter(wallpaperBG, wallpaperBG.rect, dest, new BlurFilter(8, 8, 2));

        ATimer.start(0.25, ()->{
            //var testBlurSprite:BlurredSprite = new BlurredSprite(1280, 720, 0x000000, 0, BitmapData.fromFile('assets/images/FbutteRAUtah.png'), 4, 2);
            //add(testBlurSprite);
            //var secondaryTestBlurSprite:BlurredSprite = new BlurredSprite(500, Main.pHeight, 0x000000, 0.25, BitmapData.fromFile('assets/images/FbutteRAUtah.png'), 16, 2);
            //secondaryTestBlurSprite.x = Main.pWidth-secondaryTestBlurSprite.width;
            //add(secondaryTestBlurSprite);
        });
    }
}