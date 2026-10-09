# BUILDING

So you wanna build Hydro-Frame, go ahead
>placeholder MSG, please rewrite this.

## BUILDING[ios]

>TODO

## BUILDING[android]

>TODO

## BUILDING[windows]

* Install [haxe](https://haxe.org/)
* download Hydro-Frame's repo (skip if you already have)
* in your terminal, run `haxelib git lime https://github.com/CodenameCrew/cne-lime develop; lime rebuild cpp; lime rebuild tools; haxelib git openfl https://github.com/CodenameCrew/cne-openfl develop; haxelib install svg 1.2.0` (This may take some time!)
* after those four complete, run `haxelib run lime setup`
* run `lime` in the console and make sure it worked
* (optional) run `haxelib setup` to set haxelib path
* run `haxelib install hxcpp-debugger`
* run `lime test windows -debug` (This may *also* take some time!)

## BUILDING[mac]

* Make sure you have XCode installed from the app store
* Install [haxe](https://haxe.org/)
* download Hydro-Frame's repo (skip if you already have)
* in your terminal, run `haxelib git lime https://github.com/CodenameCrew/cne-lime develop; lime rebuild mac; lime rebuild tools; haxelib git openfl https://github.com/CodenameCrew/cne-openfl develop; haxelib install svg 1.2.0` (This may take some time!)
* after those four complete, run `haxelib run lime setup`
* run `lime` in the console and make sure it worked
* (optional) run `haxelib setup` to set haxelib path
* run `haxelib install hxcpp-debugger`
* run `lime test mac -debug` (This may *also* take some time!)
