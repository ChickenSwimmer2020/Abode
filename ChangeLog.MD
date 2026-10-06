<!--markdownlint-disable MD024-->
<!--markdownlint-disable MD033 -->
# CHANGELOG

> ## 0.00.007 (ui changes, mac support, and building guide)
>
>> MacOS now compiles! (Thanks [Rex](https://github.com/RX-739)!)
>
>> mac is VERY BUGGY at the moment, failes to get desktop wallpaper, or fallback...
>>
>> fails to get the username/pcname, really broken.
>
> * added BUILDING.MD, if applicible someone fix this, it might take me a while
> * Added a TODO to `HSprite`
> * New Function for `Locale`: `getUser`
> * Updated `makeProject` prefab on `HMath`
> * `HButton` now has label access
> * Added `onGroupChange` to `HTabMenu`
> * `HTextInput` no longer gives invalid text output from non-printable keys
> * New preference! `inverseScrollDirection`
> * `InitState` refers to you by whats set in the popup on `Splash`
> * `Main` no longer crashes when *trying* to get desktop wallpaper on MacOS
> * `SplashScreen` popup finished.
>
> ## 0.00.006 (sounds and input)
>
> * New Sounds! (Thanks [HarukaStudios](https://github.com/HarukaStudios)!)
> * * `buttonClick.wav`
> * * `buttonClick2X.wav` (currently unused)
> * * `ObjectClick.wav` (currently unused)
> * * `ObjectClick2X.wav` (currently unused)
> * * `popup.wav`
> * * `Printer Sound [Begin Export].wav` (currently unused)
>
> * Added `Contributors.MD` (this is a placeholder until the `About HYDRO-FRAME` window is finished)
> * Fixed `DebugDisplay`, it also now shows if a dropdown/subdropdown is open, and if a text input is selected
> * `SymbolEditor` got closer to being usable
> * `HText` now has access to `.selectable`
> * New premade system for `HMath`
> * `HButton` has click sounds now.
> * `HColorPicker` got slightly updated
> * New Class! `ATabStack` its literally just `HTabMenu` but vertical.
> * `HTextInputBox` is ***somewhat*** functional now
> * `UPrefs` is now functional on `HTML5`
> * `HColor` now has `.toString`
> * `InitState` preferences button now opens unfinished preferences window.
> * `Main` Debugger opening logic is now properly only tied to `F11` being pressed
> * `SplashScreen` referall window updated slightly
> * `TODO` finally has an entry
>
><!---->
> ## 0.00.005 (No Clue what to name this update. :/)
>
> * Added popup for asking how the user wants to be referred to on first launch.
> * Added a lot of new language keys to the locale system
> * `HDropdown` was slightly fixed, backgrounds are still fucky.
> * `UPrefs` can actually read maps properly now.
> * `InitState` edit dropdown implementation
> * New popup on Splash screen for first launch to ask what you wanna be referred to.
>
<!---->
> ## 0.00.004 (Debugging, Symbol maker, and sub-dropdowns)
>
> * New ui debugging system.
> * `DebugDisplay` only updates fields when needed
>
>> * New Class `SymbolEditor`
>>
>>> this is being used to replace the stupid ai generated html5 one.
>
>> * New Class `UIDebugger`
>>
>>> Used for testing UI features, not much else.
>
> * Many classes now use `try` `catch(e)` loops to prevent crashes
> * `Locale` no longer imports `openfl.Assets`
>
>> * New Class `Native`
>>
>>> For accessing native system elements, like accent color!
>>>
>>> Also the reason that Hashlink compilation was removed :/
>
> * `HGroup` no longer importrs `backend.ui.HButton` or `openfl.display.DisplayObject`
> * `HSound` has unused imports removed and a `TODO` added.
>
>> * Added a (non-functional) `canInteract` system to `HState`
>> * Also added a `TODO` for auto-removal of `eventListeners`
>>
>>> Solar please fix.
>
> * `HMath` had unused imports removed.
> * Untested styling system for `HButton`
> * New Class `HCheckbox`
> * New Class `HColorPicker` (unfinished and non-functional ATM)
> * `HDropdown` is now its own class, and can attach to any `HSprite` instead of being limited to `HButton`/`HMenuBar`
> * Removed code pertaining to `HDropdown` from `HMenuBar`
> * New Class `HTabMenu`
> * New Class `HTextInputBox` (unfinished and non-functional ATM)
> * `Uprefs` no longer imports `openfl.Assets`
> * `DrawUtil` has a new icon: `"UICHECK"`.
> * `DrawUtil` now reset `lineStyle` after drawing an icon.
> * Added a `TODO` to `DrawUtil`.
> * `InitState` now enables the `F11` key to toggle fullscreen.
> * `InitState`'s entire `new` function is now a `try`-`catch(e)` system.
> * More keys in `en_US.locale`
> * Added the `general` preferences section from `Adobe animate` to `uPrefs`
> * `InitState` big updates
>
>> ## Main
>>
>> * New Static Final! `desktopBackgroundImage` (Used for caching)
>> * New Static Variable! `onKeyPressed:Map<String, {String, Bool, KeyboardEvent->Void}>`
>> * New Public Static Function! `addKeyPressed(String, Dynamic, Bool, KeyboardEvent->Void)`
>> * New Public Static Function! `removeKeyPressed(String):Bool`
>> * `New()` is now in a `try`-`catch(e)` system
>> * Support for Sub-Dropdowns.
>>
>> ## HSprite
>>
>> * New Function! `SetPositionRaw(x, y)`
>> * Removed some unneeded imports
>>
>> ## HText
>>
>> * Full Rewrite, now extends `HSprite`
>> * New Function! `setFieldSize(w, h)`
>>
>> ## HMath
>>
>> * New Function! `floor(a)`
>> * New Function! `random(a,b,c)`
>>
>> ## HColor
>>
>> * New Systems!
>>
>>> r, g, b, rgb, and a now have `get` and `set` functions.
<!---->
> ## 0.00.003 (Locales, Preferences, and project boxes)
>
> * Added user preferences system.
> * Added en_US.locale
> * `HDrawableIconGen.html` was updated with new controls
>
>> ## Main
>>
>> * `Lime.utils.Log` no longer crashes game if it cant find an asset
>>
>> ## InitState
>>
>> * Removed a random unneeded trace message
>> * Music can now be muted
>>
>> ## Network
>>
>> * New Variable! `updateCheckLocation:String`
>>
>> ## ProjectBox
>>
>> * New Function! `loadData()`
>> * `Kind:HText` -> `Desc:HText`
>>
>> ## ScrollableArea
>>
>> * Delta fix for HTML5, no longer goes at light speed.
>>
>> ## DrawUtil
>>
>> * `HDrawableIconCommand` now uses `Float` instead of `Int`
>> * New Icons!
>> * * `FILE_ANIMATE`
>> * * `FILE_HYDRO-FRAMEPROJECTFORMAT`
<!---->
> ## 0.00.002 (The Flixeling)
>
><!---->
>> ## HSound
>>
>> * Complete rewrite to use `FlxSound`'s backend
>> * > Literally just `FlxSound` atp.
>
>> ## HMath
>>
>> * Added `bound()` (From `FlxMath`)
>> * Added `even()`
>> * `lerp()` now uses Flixel style
>
>> ## New Tools Folder
>>
>> * New tool for generating `HDrawableIconCommand` arrays.
>
>> ## DrawUtil
>>
>> * New system for drawing icons on buttons
>> * Added `DrawIcon()`
>> * New Enum! `HDrawableIconCommandType`
>> * New TypeDef! `HDrawableIconCommand`
>> * New Class! `HDrawableIcons`
>> * * `SOUND`
>> * * `MUTE`
>> * * `WIN_CLOSE`
>> * * `WIN_MAX`
>> * * `WIN_MIN`
>>
>> ## HSprite
>>
>> * New Variable! `gColor:HColor`
>> * `makeGraphic` now clears graphic before starting
>> * New Function! `reRender():HSprite`
>>
>> ## HColor
>>
>> * Finally fixed alpha being buggy
>> * Removed `getRGB()`
>> * `.rgb` is now an accessible field of `HColor`
>> * `.a` is now an accessible field of `HColor`
>>
>> ## HButton
>>
>> * New Icon System!
>> * `onClick` now returns `HButton`
>> * New Function! `changeSymbol`
>>
>> ## InitState
>>
>> * Added a mute button for the music
<!---->
> ## 0.00.001 (New stuff!)
>
> * New startup sound.
> * New Main menu song
> * Started Changelog
> * Added new `Network` class.
> * Added new `HGroup<T:DisplayObject>` class.
> * Added new `HSound` class.
> * Added new `HMath` class.
> * Added new `HWindow` class.
> * Added new `HMath` class.
> * Added new `IDestroyable` interface.
>
>>>> BASIC support for HTML5 <br>
>>>> but PLEASE dont compile to it yet.
>
>> ## Main
>>
>> * Added `instance` variable.
>> * Added `vMouse` variable.
>> * Added `onStageMouseMove()`.
>> * Added `updateVirtualMouse()`.
>> * Added `addToMainStage()`.
>> * Added `removeFromMainStage()`.
><!---->
>> ## HSprite
>>
>> * now implements `IDestroyable`.
>> * `MakeGraphic()` now defaults to `TRANSPARENT`.
>> * added `screenCenter()`.
>> * added `containsMouse()`.
>>
>> > ### `getDesktopWallpaper()`
>> >
>> > * * Returns fallback correctly if null.
>> > * * Returns fallback if wallpaper isnt 16:9
><!---->
>> ## LoadingIndicator
>>
>> * `segment` is now `public`
>> * `bg` tween is now `expoInOut`
><!---->
>> ## HPoint
>>
>> * added `fromOpenflPoint()`
><!---->
>> ## HText
>>
>>* Now implements `IDestroyable`
>>* Added `destroy()`
><!---->
>> ## HTween
>>
>> * `tween()` now returns `HTween`
><!---->
>> ## ScrollableArea
>>
>> * now functional
>> * now extends `HGroup<T>`
><!---->
>> ## HasParamsUtil -> HasAttributesUtil
><!---->
>> ## InitState
>>
>> * Now plays `Vectors` looping
>> * "Check for updates..." is now functional.
>> * "About HYDRO-FRAME" is now functional.
>> * `ProjectScroller` is now functional.
><!---->
>> ## SplashScreen
>>
>> * Now plays startup sound.
>> * `loadingIndicator` is now properly centered.
