package backend.flashfile;

import sys.io.File;
import haxe.zip.Reader;
import haxe.io.Bytes;
import backend.utils.Type.OneOfTwo;
import backend.utils.APoint;
import openfl.geom.Matrix;

using StringTools;

typedef FlashMedia = {
    var name:String;
    var itemID:String;
    var sourceExternalFilepath:String;
    var sourceLastImported:Int;
    var externalFileCRC32:Int;
    var externalFileSize:Int;
    var allowSmoothing:Bool;
    var useImportedJPEGData:Bool;
    var compressionType:String;
    var originalCompressionType:String;
    var quality:Int;
    var href:String;
    var bitmapDataHRef:String;
    var frameRight:Int;
    var frameBottom:Int;
}
typedef FlashSymbol = {
    var href:String;
    var loadImmediate:Bool;
    var itemID:String;
    var lastModified:Int;
}
typedef FlashTween = {
    var target:String;
    var method:String;
} 
typedef FlashSymbolFilter = {
    //!! ALL THINGS ARE OPTIONAL DUE TO THE NATURE OF FILTERS
    var type:String; //! NOT IN ORIGINAL, EXCLUSIVE HERE SO WE KNOW WHAT TYPE OF FILTER IT IS

    @:optional var blurX:Int;
    @:optional var blurY:Int;
    @:optional var quality:Int;
    @:optional var inner:Bool;
    @:optional var color:String; //string based color "#"
    @:optional var strength:Float;                                                
} 
typedef FlashSymbolInstance = {
    var libraryName:String;
    var symbolType:String;
    var loop:String;
    var matrix:Matrix; //* CONFIRMED
    var transformationPoint:APoint;
    var filters:Array<FlashSymbolFilter>;
    //missed more :/
    @:optional var centerPoint3DX:Float;
    @:optional var centerPoint3DY:Float;
} 
//HORRIBLY FORMATTED.
typedef FlashShapeInstance = {
    var strokes:Array<{
        StrokeStyleIndex:Int,
        StrokeStyle:Array<{
            scaleMode:String,
            caps:String,
            weight:Int,
            joints:String,
            SolidStroke:Array<{color:String}>
        }>
    }>;
    var edges:Array<{
        strokeStyle:Int,
        edges:String //! "!4788 3052[#1389.E1 #CA0.C3 5028 3509!5028 3509[#13A3.34 #EE9.35 4797 3954" THE FUCK?!
    }>;
} 
typedef FlashFrame = {
    var index:Int;
    var duration:Int; //im assuming in frames.
    var keyMode:Int; //????
    //whoops, missed a couple possibly.
    @:optional var tweenType:String;
    @:optional var motionTweenSnap:Bool;
    @:optional var easeMethodName:String;
    @:optional var motionTweenScale:Bool;
    @:optional var rigPropagationMatrix:Matrix; //stored weirdly in the xml for some reason '{"a":65536,"b":0,"c":9135,"d":65536,"tx":-506,"ty":0}'

    var tweens:Array<FlashTween>;
    var elements:Array<OneOfTwo<FlashSymbolInstance, FlashShapeInstance>>;
} 
typedef FlashLayer = {
    var name:String;
    var color:String; //interestingly, these colors are based on strings!
    var frames:Array<FlashFrame>;
    //HOW DO I KEEP MISSING THINGS.
    @:optional var current:Bool;
    @:optional var isSelected:Bool;
    @:optional var autoNamed:Bool;
} 
typedef FlashTimeline = {
    var name:String;
    var layerDepthEnabled:Bool;
    var layers:Array<FlashLayer>;
}
typedef FlashSolidSwatchItem = { //these all appear to be optional, idk how that works but OK.
    @:optional var color:String;
    @:optional var hue:Int;
    @:optional var saturation:Int;
    @:optional var brightness:Int;
} 
typedef FlashSwatchList = {
    var name:String;
    var swatches:Array<FlashSolidSwatchItem>;
} 
typedef DOMDocument = {
    var width:Int;
    var height:Int;
    var currentTimeline:Int;
    var xflVersion:Float; //just for safe keeping, we arent going to touch this.
    var creatorInfo:String;
    var platform:String;
    var versionInfo:String;
    var majorVersion:Int;
    var buildNumber:Int;
    var viewAngle3D:Float;
    var vanishingPoint3DX:Int;
    var vanishingPoint3DY:Int;
    var nextSceneIdentifier:Int;
    //?? the hell do these do.
        var playOptionsPlayLoop:Bool;
        var playOptionsPlayPages:Bool;
        var playOptionsPlayFrameActions:Bool;
    var filetypeGUID:String; //dont touch
    var fileGUID:String; //also dont touch
    var file:FlashFile;
}
typedef FlashFile = {
    var media:Array<FlashMedia>;
    var Symbols:Array<FlashSymbol>;
    var Timelines:Array<FlashTimeline>;
    var swatchLists:Array<FlashSwatchList>;
}

//solar, i WILL leave rendering to you, but i just wanna make sure that this reading system actually works.
class FlashReader {
    public static function parseFlaFile(file:String):DOMDocument { //return a completed DOMDocument instance from parsing a Flash file.
        var toReturn:DOMDocument;
        var internalXmls:Map<String,String>=[];
        if(file=="IntroAnim.fla" || file=="IntroAnim") {
            var file = File.read('assets/IntroAnim.fla', true);
            var reader:Reader = new Reader(file);
            var entries = reader.read();
            for (entry in entries) {
                trace(entry.fileName);
                try {
                    if(entry.fileName.endsWith('.xml')) {
                        try {
                            var unc = new haxe.zip.Uncompress(-15);
                            unc.setFlushMode(haxe.zip.FlushMode.SYNC);
                            var bufSize = entry.dataSize * 4; // start at 4x
                            var buf = haxe.io.Bytes.alloc(bufSize);
                            var r = unc.execute(entry.data, 0, buf, 0);

                            // if we used the whole buffer, it probably got cut off, so try bigger
                            while (r.write == bufSize) {
                                bufSize *= 2;
                                buf = haxe.io.Bytes.alloc(bufSize);
                                unc = new haxe.zip.Uncompress(-15);
                                unc.setFlushMode(haxe.zip.FlushMode.SYNC);
                                r = unc.execute(entry.data, 0, buf, 0);
                            }

                            unc.close();
                            var content = buf.getString(0, r.write);
                            internalXmls.set(entry.fileName, content);
                        } catch(e:Dynamic) {
                            // if decompress fails, try raw
                            trace('decompress failed, trying raw: $e');
                            trace(entry.data.toString());
                            trace('this could also be because the file is empty, please verify.');
                        }
                    }else if(entry.fileName.endsWith('.png')){
                        trace('not even trying it, png file.');
                    }else if(entry.fileName.endsWith('.dat') || entry.fileName.endsWith('.cache')){
                        trace('file is unsupported/not needed, ignoring "${entry.fileName}"');
                    }else{
                        var bytes = entry.compressed ? haxe.zip.Uncompress.run(entry.data, entry.dataSize) : entry.data;
                        var content = bytes.toString();
                        trace(content);
                    }
                } catch(e:Dynamic) {
                    trace('failed to read entry ${entry.fileName}: $e');
                }
            }
            file.close();

            var domDocument:Xml = Xml.parse(internalXmls.get('DOMDocument.xml')); //we can parse this now :3
            var root:Xml = domDocument.firstChild();

            toReturn={
                width: Std.parseInt(root.get("width")),
                height: Std.parseInt(root.get("height")),
                currentTimeline: Std.parseInt(root.get("currentTimeline")),
                xflVersion: Std.parseFloat(root.get("xflVersion")),
                creatorInfo: root.get("creatorInfo"),
                platform: root.get("platform"),
                versionInfo: root.get("versionInfo"),
                majorVersion: Std.parseInt(root.get("majorVersion")),
                buildNumber: Std.parseInt(root.get("buildNumber")),
                viewAngle3D: Std.parseFloat(root.get("viewAngle3D")),
                vanishingPoint3DX: Std.parseInt(root.get("vanishingPoint3DX")),
                vanishingPoint3DY: Std.parseInt(root.get("vanishingPoint3DY")),
                nextSceneIdentifier: Std.parseInt(root.get("nextSceneIdentifier")),
                playOptionsPlayLoop: root.get("playOptionsPlayLoop") == "true",
                playOptionsPlayPages: root.get("playOptionsPlayPages") == "true",
                playOptionsPlayFrameActions: root.get("playOptionsPlayFrameActions") == "true",
                filetypeGUID: root.get("filetypeGUID"),
                fileGUID: root.get("fileGUID"),
                file: {
                    media: [],
                    Symbols: [],
                    Timelines: [],
                    swatchLists: []
                }
            };

            return toReturn;
        }else{

        }
        return null;
    }


    private static function getSwatches() {
        
    }
}