package backend;

class UPrefs {
    private static final DEFAULT_PREFERENCES:Dynamic = {
        mainMenuMuted: false,
        #if debug
            debuggerVisible: true,
        #end
        //editor
        undoType: ["DocumentLevel"=>true, "ObjectLevel"=>false],
        undoLevels: 100,
        autoRecovery: true,
        autoRecoveryTime: 10,
        uiTheme: ["Darkest"=>false, "Dark"=>true, "Light"=>false, "Lightest"=>false],
        uiAppearance: ["Comfortable"=>true, "Compact"=>false],
        enableShading: true,
        hideStageBorder: false,
        useOutlinesForPanning: false,
        autoCollapseIconPanels: true,
        seperateProjectsAndScriptWindows: false,
        useCustomColorsForHighlights: false,
        groupCustomColor: 0xFF1cbbb4,
        objectCustomColor: 0xFF00a8ff,
        otherCustomColor: 0xFF0066ff,
        perferredReference: ["Custom"=>false, "WINUser"=>false, "PCName"=>false, "NOT SELECTED"=>true],
        customReferenceName: ""
    };
    //settings (non-editor settings)
    public static var perferredReference:Preference<Map<String, Bool>> = new Preference("perferredReference", ["Custom"=>false, "WINUser"=>false, "PCName"=>false, "NOT SELECTED"=>true]);
    public static var customReferenceName:Preference<String> = new Preference("customReferenceName", "");
    public static var mainMenuMuted:Preference<Bool> = new Preference("mainMenuMuted", false); //this is stupid. i wanted to do Uprefs.setting. but noooo, macros are black magic.

    //settings (editor)
    public static var undoType:Preference<Map<String, Bool>> = new Preference("undoType", ["DocumentLevel"=>true, "ObjectLevel"=>false]);
    public static var undoLevels:Preference<Int> = new Preference("undoLevels", 100);
    public static var autoRecovery:Preference<Bool> = new Preference("autoRecovery", true);
    public static var autoRecoveryTime:Preference<Int> = new Preference("autoRecoveryTime", 10);
    public static var uiTheme:Preference<Map<String, Bool>> = new Preference("uiTheme", ["Darkest"=>false, "Dark"=>true, "Light"=>false, "Lightest"=>false]);
    public static var uiAppearance:Preference<Map<String, Bool>> = new Preference("uiAppearance", ["Comfortable"=>true, "Compact"=>false]);
    public static var enableShading:Preference<Bool> = new Preference("enableShading", true);
    public static var hideStageBorder:Preference<Bool> = new Preference("hideStageBorder", false);
    public static var useOutlinesForPanning:Preference<Bool> = new Preference("useOutlinesForPanning", false);
    public static var autoCollapseIconPanels:Preference<Bool> = new Preference("autoCollapseIconPanels", true);
    public static var seperateProjectsAndScriptWindows:Preference<Bool> = new Preference("seperateProjectsAndScriptWindows", false);
    public static var useCustomColorsForHighlights:Preference<Bool> = new Preference("useCustomColorsForHighlights", false);
    public static var groupCustomColor:Preference<AColor> = new Preference("groupCustomColor", 0xFF1cbbb4);
    public static var objectCustomColor:Preference<AColor> = new Preference("objectCustomColor", 0xFF00a8ff);
    public static var otherCustomColor:Preference<AColor> = new Preference("otherCustomColor", 0xFF0066ff);


    #if debug
        public static var debuggerVisible:Preference<Bool> = new Preference("debuggerVisible", true); //this is stupid. i wanted to do Uprefs.setting. but noooo, macros are black magic.
    #end




    public static function getFromFile(a:String):Dynamic{
        var v:Dynamic = Reflect.getProperty(Json.parse(getPrefsFile()), a); //inital json data.
        if(v!=null&&Type.typeof(v)==TObject) { //map fix, so maps can be parsed correctly cuz apparently casting is stupid.
            var m = new Map<Dynamic, Dynamic>();
            for(f in Reflect.fields(v)) m.set(f, Reflect.field(v, f));
            return m;
        }
        return v;
    }
    public static function writeToFile(a:String, b:Dynamic):Dynamic {
        var json:Dynamic = Json.parse(getPrefsFile());
        Reflect.setField(json, a, b);
        trace('Setting field $a to $b in UPrefs.');
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
    public var name:String;
    @:isVar public var value(get, set):T;
    public inline function get_value():T return (UPrefs.getFromFile(name):T); //safety
    public inline function set_value(a:T):T return UPrefs.writeToFile(name, a);
    public function new(n:String, v:T) {
        name = n;
        @:bypassAccessor value = v;
    }
}