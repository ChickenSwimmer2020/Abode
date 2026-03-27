package backend.flashfile;

import haxe.Json;
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
typedef FlashGradientEntry = {
    var color:String;
    var ratio:Float;
    var alpha:Float;
}
typedef FlashSymbolFilter = {
    var type:String; //! NOT IN ORIGINAL, EXCLUSIVE HERE SO WE KNOW WHAT TYPE OF FILTER IT IS

    @:optional var blurX:Int;
    @:optional var blurY:Int;
    @:optional var distance:Int;
    @:optional var quality:Int;
    @:optional var inner:Bool;
    @:optional var color:String; //string based color "#"
    @:optional var strength:Float;      
    @:optional var GradientEntrys:Array<FlashGradientEntry>;
    @:optional var glowType:String; //originally called "type" but we're using that.
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
    public static function parseFlaFile(input:String):DOMDocument { //return a completed DOMDocument instance from parsing a Flash file.
        var toReturn:DOMDocument;
        var internalXmls:Map<String,String>=[];
        if(input=="IntroAnim.fla" || input=="IntroAnim") {
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
                            
                            var maxAttempts = 8;
                            var attempts = 0;
                            while (r.write == bufSize && attempts < maxAttempts) {
                                attempts++;
                                bufSize *= 2;
                                buf = haxe.io.Bytes.alloc(bufSize);
                                unc = new haxe.zip.Uncompress(-15);
                                unc.setFlushMode(haxe.zip.FlushMode.SYNC);
                                r = unc.execute(entry.data, 0, buf, 0);
                            }
                            if (attempts >= maxAttempts) {
                                trace('WARNING: buffer resize hit max attempts for ${entry.fileName}, data may be truncated');
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
            
            var swatchLists:Xml=null;
            var symbols:Xml=null;
            var timelines:Xml=null;
            var media:Xml=null;
            for(element in root.elements()) {
                switch(element.nodeName) {
                    case "media": media = element;
                    case "symbols": symbols = element;
                    case "timelines": timelines = element;
                    case "swatchLists": swatchLists = element;
                    default: trace('unneeded node name "${element.nodeName}"');
                }
            }

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
                    media: getMedia(media),
                    Symbols: getSymbols(symbols),
                    Timelines: getTimelines(timelines),
                    swatchLists: getSwatches(swatchLists),
                }
            };

            #if debug File.saveContent('assets/${input}_DEBUGLOG.json', Json.stringify(toReturn, null, "    ")); #end
            return toReturn;
        }else{

        }
        return null;
    }

    //!! WARNING, LARGE FUNCTION. VERY UN-CLEAN
    private static function getTimelines(timelines:Xml):Array<FlashTimeline> {
        var TimeLines:Array<FlashTimeline>=[];
        for(timeline in timelines.elements()) {
            var TimeLine:FlashTimeline = {name: timeline.get('name'),layerDepthEnabled: timeline.get('layerDepthEnabled')=="true",layers: []};
            var Layers:Array<FlashLayer>=[];
            for(layer in timeline.firstElement().elements()) { //layers.elements basically
                var Layer:FlashLayer = {
                    name: layer.get('name'),
                    color: layer.get('color'),
                    frames: [], //WILL GET DONE
                    current: (layer.get('current')??"false")=="true",
                    isSelected: (layer.get('isSelected')??"false")=="true",
                    autoNamed: (layer.get('autoNamed')??"false")=="true",
                };
                var Frames:Array<FlashFrame>=[];
                for(frame in layer.firstElement().elements()) {
                    var Frame:FlashFrame;
                    Frame = {
                        index: Std.parseInt(frame.get('index')),
                        duration: Std.parseInt(frame.get('duration')??"1"), //default to one frame if null.
                        keyMode: Std.parseInt(frame.get('keyMode')),
                        tweenType: frame.get('tweenType')??"",
                        motionTweenSnap: (frame.get('motionTweenSnap')??"false")=="true",
                        easeMethodName: frame.get('easeMethodName')??"",
                        motionTweenScale: (frame.get('motionTweenScale')??"false")=="true",
                        rigPropagationMatrix: matrixFromString(frame.get('rigPropagationMatrix'))??new Matrix(1,0,0,1,0,0),
                        tweens: [],
                        elements: []
                    };
                    var Tweens:Array<FlashTween>=[];
                    var Elements:Array<FlashSymbolInstance>=[];
                    for(tweenorobject in frame.elements()) {
                        switch (tweenorobject.nodeName) {
                            case 'tweens': for(tween in tweenorobject.elements()) Tweens.push({target: tween.get('target'),method: tween.get('method')});
                            case 'elements':
                                for(element in tweenorobject.elements()) {
                                        var Element:FlashSymbolInstance;
                                        var Filters:Array<FlashSymbolFilter>=[];
                                        var matrixElement = element.elementsNamed('matrix').next();
                                        var transformElement = element.elementsNamed('transformationPoint').next();
                                        Element = {
                                            libraryName: element.get('libraryItemName')??"ERROR: PLEASE FIX ME!",
                                            symbolType: element.get('symbolType') ?? "",
                                            loop: element.get('loop') ?? "loopPlay",
                                            matrix: matrixElement!=null?parseMatrix(matrixElement.firstElement()):new Matrix(1,0,0,1,0,0),
                                            transformationPoint: transformElement != null ? parsePoint(transformElement.firstElement()) : new APoint(0, 0),
                                            filters: [],
                                            centerPoint3DX: Std.parseFloat(element.get('centerPoint3DX')??"0"),
                                            centerPoint3DY: Std.parseFloat(element.get('centerPoint3DY')??"0"),
                                        };
                                        var filtersElement = element.elementsNamed('filters').next();
                                        if(filtersElement != null) {
                                            for(filterItem in filtersElement.elements()) {
                                                var Filter:FlashSymbolFilter;
                                                Filter = {
                                                    type: filterItem.nodeName,
                                                    blurX: Std.parseInt(filterItem.get('blurX')??"0"),
                                                    blurY: Std.parseInt(filterItem.get('blurY')??"0"),
                                                    quality: Std.parseInt(filterItem.get('quality')??"1"),
                                                    inner: (filterItem.get('inner')??"false")=="true",
                                                    color: filterItem.get('color')??"#FF00FF", //magenta, signalling a problem
                                                    strength: Std.parseFloat(filterItem.get('strength')??"0"),

                                                    distance: Std.parseInt(filterItem.get('distance')??"0"),
                                                    GradientEntrys: [],
                                                    glowType: filterItem.get('type')??"outer",  
                                                };
                                                var Gradients:Array<FlashGradientEntry>=[];
                                                var gradientEnteryarea:Xml = filterItem.elementsNamed('GradientEntry').next();
                                                if(gradientEnteryarea!=null) {
                                                    for(gradientEntry in gradientEnteryarea.elements()) {
                                                        if(gradientEntry.nodeName=="GradientGlowFilter"||gradientEntry.nodeName=="GradientBevelFilter"){
                                                            Gradients.push({
                                                                color: gradientEntry.get('color')??"#FF00FF",
                                                                alpha: Std.parseFloat(gradientEntry.get('alpha')??"1"),
                                                                ratio: Std.parseFloat(gradientEntry.get('ratio')??"0"),
                                                            });
                                                        }
                                                    }
                                                    Filter.GradientEntrys = Gradients;
                                                }
                                                Filters.push(Filter);
                                            }
                                        }
                                        Element.filters = Filters;
                                        Elements.push(Element);
                                }
                            default: trace('unknown nodename in frame object "${tweenorobject.nodeName}"');
                        }
                    }
                    Frame.tweens = Tweens;
                    Frame.elements = Elements;
                    Frames.push(Frame);
                }
                Layer.frames = Frames;
                Layers.push(Layer);
            }
            TimeLine.layers = Layers;
            TimeLines.push(TimeLine);
        }
        return TimeLines;
    }
    private static inline function parsePoint(element:Xml):APoint return new APoint(Std.parseFloat(element.get('x')), Std.parseFloat(element.get('y')));

    private static inline function parseMatrix(element:Xml):Matrix return new Matrix(
        Std.parseFloat(element.get('a')??"1"), //proper defaulting i guess.
        Std.parseFloat(element.get('b')??"0"),
        Std.parseFloat(element.get('c')??"0"),
        Std.parseFloat(element.get('d')??"1"),
        Std.parseFloat(element.get('tx')??"0"),
        Std.parseFloat(element.get('ty')??"0")
    );

    private static function matrixFromString(input:String):Matrix {
        if(input==null) return null; //simple
        var json:Dynamic = Json.parse(input);
        return new Matrix(json.a??1,json.b??0,json.c??0,json.d??1,json.tx??0,json.ty??0);
    }

    private static function getSymbols(symbols:Xml):Array<FlashSymbol> {
        var returnGroup:Array<FlashSymbol>=[];
        for(element in symbols.elements()) {
            switch(element.nodeName){
                case 'Include': returnGroup.push({
                    href: element.get('href'),
                    loadImmediate: element.get('loadImmediate')=="true",
                    itemID: element.get('itemID'),
                    lastModified: Std.parseInt(element.get('lastModified'))
                });
                default: trace('unknown symbol nodename. "${element.nodeName}"');
            }
        }
        return returnGroup;
    }
    private static function getMedia(media:Xml):Array<FlashMedia> {
        var returnGroup:Array<FlashMedia>=[];
        for(element in media.elements()) {
            switch(element.nodeName) {
                case 'DOMBitmapItem': returnGroup.push({
                    name: element.get('name'),
                    itemID: element.get('itemID'),
                    sourceExternalFilepath: element.get('sourceExternalFilepath'),
                    sourceLastImported: Std.parseInt(element.get('sourceLastImported')),
                    externalFileCRC32: Std.parseInt(element.get('externalFileCRC32')),
                    externalFileSize: Std.parseInt(element.get('externalFileSize')),
                    allowSmoothing: element.get('allowSmoothing') == 'true',
                    useImportedJPEGData: element.get('useImportedJPEGData') == 'true',
                    compressionType: element.get('compressionType'),
                    originalCompressionType: element.get('originalCompressionType'),
                    quality: Std.parseInt(element.get('quality')),
                    href: element.get('href'),
                    bitmapDataHRef: element.get('bitmapDataHRef'),
                    frameRight: Std.parseInt(element.get('frameRight')),
                    frameBottom: Std.parseInt(element.get('frameBottom')),
                });
                default: trace('unknown or unsupported node type! "${element.nodeName}"');
            }
        }
        return returnGroup;
    }
    private static function getSwatches(swatches:Xml):Array<FlashSwatchList> {
        var returnedGroups:Array<FlashSwatchList>=[];
        for(element in swatches.elements()) {
            //element is swatchlist
            var swatchList:FlashSwatchList = {name: element.firstElement().get('name'), swatches: []};
            var swatchets:Array<FlashSolidSwatchItem> = []; //{brightness: null, color: null, hue: null, saturation: null};
            for(subElement in element.elements()) {
                if(subElement.nodeName == 'swatches') {
                    for(SWATCH in subElement.elements()) {
                        switch(SWATCH.nodeName) {
                            case 'SolidSwatchItem': swatchets.push({
                                color: SWATCH.get('color')??"#FF00FF", //default to magenta if no color
                                hue: Std.parseInt(SWATCH.get('hue'))??0,
                                saturation: Std.parseInt(SWATCH.get('saturation'))??0,
                                brightness: Std.parseInt(SWATCH.get('brightness'))??0
                            });
                            default: trace('unknown swatch object "${SWATCH.nodeName}"');
                        }
                    }
                }
            }
            swatchList.swatches = swatchets;
            returnedGroups.push(swatchList);
        }
        return returnedGroups;
    }
}