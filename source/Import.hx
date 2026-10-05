package;

#if debug 
    //debugging imports
    import backend.debug.DebugDisplay;
    import backend.debug.UIDebugger;
    import backend.debug.SymbolEditor;
#end

//backend imports
import backend.ASprite;
import backend.LoadingIndicator;
import backend.Native;

import backend.Locale;
import backend.UPrefs;
import backend.Network;
    //objects
        import backend.objects.ATimer;
        import backend.objects.AState;
        import backend.objects.APoint;
        import backend.objects.ATween.AEase;
        import backend.objects.ATween;
        import backend.objects.AText;
        import backend.objects.InitalState.StateSystemInit;
        import backend.objects.AWindowManager;
        import backend.objects.ASound;
        import backend.objects.AGroup;
        import backend.objects.ASound.ASoundManager;
    //utils
        import backend.utils.IHasAttributes;
        import backend.utils.Type.OneOfThree;
        import backend.utils.Type.OneOfTwo;
        import backend.utils.AColor;
        import backend.utils.IDestroyable;
        import backend.utils.AMath;
    //ui
        import backend.ui.AMenuBar;
        import backend.ui.ProjectBox;
        import backend.ui.ScrollableArea;
        import backend.ui.AButton;
        import backend.ui.ATabMenu;
        import backend.ui.ACheckBox;
        import backend.ui.ATextInputBox;
        import backend.ui.ADropdown;

import backend.flashfile.FLAParser.FlashReader;

//openfl imports
import openfl.display.BitmapData;
import openfl.display.Sprite;
import openfl.filters.BlurFilter;
import openfl.display.DisplayObject;
import openfl.display.BlendMode;
import openfl.filters.ShaderFilter;
import openfl.ui.Mouse;
import openfl.events.Event;
import openfl.text.TextFormatAlign;
import openfl.system.Capabilities;
import openfl.geom.Matrix;
import openfl.events.TimerEvent;
import openfl.utils.Timer;
import openfl.system.System;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.geom.Rectangle;
import openfl.display.StageAlign;
import openfl.geom.Point;
import openfl.display.StageScaleMode;
import openfl.events.MouseEvent;
import openfl.Lib;
import openfl.events.UncaughtErrorEvent;
import openfl.events.ErrorEvent;
import openfl.filters.BitmapFilter;
import openfl.ui.Keyboard;
import openfl.events.KeyboardEvent;
import openfl.geom.ColorTransform;
import openfl.Assets;
import openfl.net.SharedObject;
import openfl.net.URLRequest;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;
import openfl.media.Sound;

//lime imports
import lime.graphics.Image;
import lime.app.Application;
import lime.utils.AssetLibrary;
import lime.graphics.RenderContext;
import lime.ui.Window;
import lime.utils.Log;

//sys imports
#if sys
    import sys.io.File;
    import sys.FileSystem;
    import sys.Http;
#elseif html5
    import haxe.Http;
#end

//haxe imports
import haxe.Json;
import haxe.zip.Reader;
import haxe.io.Bytes;
import haxe.Exception;

//usings
using backend.utils.DrawUtil;
using backend.utils.ArrayUtil;
using backend.utils.AMath;
using StringTools;