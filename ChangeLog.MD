# CHANGELOG

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
>>>> BASIC support for HTML5 <br> <!--markdownlint-disable-line MD033 -->
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
