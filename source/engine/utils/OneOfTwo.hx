package engine.utils;

/**
 * Useful to limit a Dynamic function argument's type to the specified
 * type parameters. This does NOT make the use of Dynamic type-safe in
 * any way (the underlying type is still Dynamic and Std.isOfType() checks +
 * casts are necessary).
 * 
 * ***TAKEN FROM [HAXEFLIXEL](https://github.com/HaxeFlixel/flixel/blob/master/flixel/util/typeLimit/OneOfTwo.hx)!!***
 */
abstract OneOfTwo<T1, T2>(Dynamic) from T1 from T2 to T1 to T2 {}
