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
        otherCustomColor: 0xFF0066ff
    };
    //settings (non-editor settings)
    public static var mainMenuMuted:Preference<Bool> = new Preference("mainMenuMuted", false, getFromFile, writeToFile); //this is stupid. i wanted to do Uprefs.setting. but noooo, macros are black magic.

    //settings (editor)
    public static var undoType:Preference<Map<String,Bool>> = new Preference("undoType", ["DocumentLevel"=>true, "ObjectLevel"=>false], getFromFile, writeToFile);
    public static var undoLevels:Preference<Int> = new Preference("undoLevels", 100, getFromFile, writeToFile);
    public static var autoRecovery:Preference<Bool> = new Preference("autoRecovery", true, getFromFile, writeToFile);
    public static var autoRecoveryTime:Preference<Int> = new Preference("autoRecoveryTime", 10, getFromFile, writeToFile);
    public static var uiTheme:Preference<Map<String,Bool>> = new Preference("uiTheme", ["Darkest"=>false, "Dark"=>true, "Light"=>false, "Lightest"=>false], getFromFile, writeToFile);
    public static var uiSize:Preference<Map<String,Bool>> = new Preference("uiAppearance", ["Comfortable"=>true, "Compact"=>false], getFromFile, writeToFile);
    public static var enableShading:Preference<Bool> = new Preference("enableShading", true, getFromFile, writeToFile);
    public static var hideStageBorder:Preference<Bool> = new Preference("hideStageBorder", false, getFromFile, writeToFile);
    public static var useOutlinesForPanning:Preference<Bool> = new Preference("useOutlinesForPanning", false, getFromFile, writeToFile);
    public static var autoCollapseIconPanels:Preference<Bool> = new Preference("autoCollapseIconPanels", true, getFromFile, writeToFile);
    public static var seperateProjectsAndScriptWindows:Preference<Bool> = new Preference("seperateProjectsAndScriptWindows", false, getFromFile, writeToFile);
    public static var useCustomColorsForHighlights:Preference<Bool> = new Preference("useCustomColorsForHighlights", false, getFromFile, writeToFile);
    public static var groupCustomColor:Preference<AColor> = new Preference("groupCustomColor", 0xFF1cbbb4, getFromFile, writeToFile);
    public static var objectCustomColor:Preference<AColor> = new Preference("objectCustomColor", 0xFF00a8ff, getFromFile, writeToFile);
    public static var otherCustomColor:Preference<AColor> = new Preference("otherCustomColor", 0xFF0066ff, getFromFile, writeToFile);


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
