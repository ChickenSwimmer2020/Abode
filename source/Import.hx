package;

#if !macro
#if debug
// debugging imports
import backend.debug.DebugDisplay;
import backend.debug.UIDebugger;
import backend.debug.SymbolEditor;
#end
// backend imports
import backend.HSprite;
import backend.LoadingIndicator;
import backend.Native;
import backend.Locale;
import backend.UPrefs;
import backend.Network;
// objects
import backend.objects.HTimer;
import backend.objects.HState;
import backend.objects.HPoint;
import backend.objects.HTween.AEase;
import backend.objects.HTween;
import backend.objects.HText;
import backend.objects.InitalState.StateSystemInit;
import backend.objects.HSound;
import backend.objects.HWindowManager;
import backend.objects.HGroup;
import backend.objects.HSound.HSoundManager;
// utils
import backend.utils.IHasAttributes;
import backend.utils.Type.OneOfThree;
import backend.utils.Type.OneOfTwo;
import backend.utils.HColor;
import backend.utils.IDestroyable;
import backend.utils.HMath;
// ui
import backend.ui.HMenuBar;
import backend.ui.ProjectBox;
import backend.ui.ScrollableArea;
import backend.ui.HButton;
import backend.ui.HTabMenu;
import backend.ui.HCheckbox;
import backend.ui.HTextInputBox;
import backend.ui.HDropdown;
// openfl imports
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
// lime imports
import lime.graphics.Image;
import lime.app.Application;
import lime.utils.AssetLibrary;
import lime.graphics.RenderContext;
import lime.ui.Window;
import lime.utils.Log;
// sys imports
#if sys
import sys.io.File;
import sys.FileSystem;
import sys.Http;
#elseif html5
import haxe.Http;
#end
// haxe imports
import haxe.Json;
import haxe.zip.Reader;
import haxe.io.Bytes;
import haxe.Exception;
import haxe.DynamicAccess;
import haxe.PosInfos;

// usings
using backend.utils.DrawUtil;
using backend.utils.ArrayUtil;
using backend.utils.HMath;
using StringTools;

#end