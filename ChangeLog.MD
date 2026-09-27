<!--markdownlint-disable MD024-->
<!--markdownlint-disable MD033 -->
# CHANGELOG

> ## 0.00.002 (The Flixeling)
>
><!---->
>> ## ASound
>>
>> * Complete rewrite to use `FlxSound`'s backend
>> * > Literally just `FlxSound` atp.
>
>> ## AMath
>>
>> * Added `bound()` (From `FlxMath`)
>> * Added `even()`
>> * `lerp()` now uses Flixel style
>
>> ## New Tools Folder
>>
>> * New tool for generating `ADrawableIconCommand` arrays.
>
>> ## DrawUtil
>>
>> * New system for drawing icons on buttons
>> * Added `DrawIcon()`
>> * New Enum! `ADrawableIconCommandType`
>> * New TypeDef! `ADrawableIconCommand`
>> * New Class! `ADrawableIcons`
>> * * `SOUND`
>> * * `MUTE`
>> * * `WIN_CLOSE`
>> * * `WIN_MAX`
>> * * `WIN_MIN`
>>
>> ## ASprite
>>
>> * New Variable! `gColor:Acolor`
>> * `makeGraphic` now clears graphic before starting
>> * New Function! `reRender():ASprite`
>>
>> ## AColor
>>
>> * Finally fixed alpha being buggy
>> * Removed `getRGB()`
>> * `.rgb` is now an accessible field of `AColor`
>> * `.a` is now an accessible field of `AColor`
>>
>> ## AButton
>>
>> * New Icon System!
>> * `onClick` now returns `AButton`
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
> * Added new `AGroup<T:DisplayObject>` class.
> * Added new `ASound` class.
> * Added new `AWindowManager` class.
> * Added new `AWindow` class.
> * Added new `AMath` class.
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
>> ## ASprite
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
>> ## APoint
>>
>> * added `fromOpenflPoint()`
><!---->
>> ## AText
>>
>>* Now implements `IDestroyable`
>>* Added `destroy()`
><!---->
>> ## ATween
>>
>> * `tween()` now returns `ATween`
><!---->
>> ## ScrollableArea
>>
>> * now functional
>> * now extends `AGroup<T>`
><!---->
>> ## HasParamsUtil -> HasAttributesUtil
><!---->
>> ## InitState
>>
>> * Now plays `Vectors` looping
>> * "Check for updates..." is now functional.
>> * "About Abode" is now functional.
>> * `ProjectScroller` is now functional.
><!---->
>> ## SplashScreen
>>
>> * Now plays startup sound.
>> * `loadingIndicator` is now properly centered.
