package backend;

import openfl.Assets;

class UPrefs {
    private static final DEFAULT_PREFERENCES:Dynamic = {
        mainMenuMuted: false,
        #if debug
            debuggerVisible: true
        #end
    };
    //settings.
    public static var mainMenuMuted:Preference<Bool> = new Preference("mainMenuMuted", false, getFromFile, writeToFile); //this is stupid. i wanted to do Uprefs.setting. but noooo, macros are black magic.

    #if debug
        public static var debuggerVisible:Preference<Bool> = new Preference("debuggerVisible", true, getFromFile, writeToFile); //this is stupid. i wanted to do Uprefs.setting. but noooo, macros are black magic.
    #end




    public static function getFromFile(a:String):Dynamic return Reflect.getProperty(Json.parse(getPrefsFile()), a);
    public static function writeToFile(a:String, b:Dynamic):Dynamic {
        var json:Dynamic = Json.parse(getPrefsFile());
        Reflect.setField(json, a, b);
        #if sys File.saveContent("uPrefs.json", Json.stringify(json, null,"    "));
        #else
            trace("Not implemented");
        #end
        return b;
    }

    public static function getPrefsFile():String {
        #if sys return (FileSystem.exists("uPrefs.json"))?File.getContent("uPrefs.json"):makePrefsFile();
        #else
            trace("Not implemented");
        #end
        return "{}"; //so it doesnt crash on html5.
    }

    public static function makePrefsFile():String {
        #if sys File.saveContent("uPrefs.json", Json.stringify(DEFAULT_PREFERENCES, null, "    "));
        #else
            trace("Not Implemented");
        #end

        return #if(sys)File.getContent("uPrefs.json")#else "{}"#end;
    }
}

class Preference<T> {
    private var oG:String->T;
    private var oW:(String, T)->T;
    public var name:String;
    @:isVar public var value(get, set):T;
    public inline function get_value():T return oG(name);
    public inline function set_value(a:T):T return oW(name, a);
    public function new(n:String, v:T, onGet:String->T, onWrite:(String, T)->T) {
        name = n;
        @:bypassAccessor value = v;

        oG = onGet;
        oW = onWrite;
    }
}
