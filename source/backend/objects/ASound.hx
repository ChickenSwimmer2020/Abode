package backend.objects;

import openfl.media.SoundTransform;
import openfl.media.Sound;
import openfl.Assets;

class ASound {
    public static var music:Null<Sound> = null;
    public static function playSound(path:String, volume:Float) {
        var sound:Sound = Assets.getSound(path);
        
        // Play the sound immediately
        sound.play(0.0, 0, new SoundTransform(volume));
    }

    public static function playMusic(path:String, volume:Float) {
        if(music!=null){
            music.close();
            music = null;
        }
        music = Assets.getSound(path);
        music.play(0.0, 999999, new SoundTransform(volume));
    }
}