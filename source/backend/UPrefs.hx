package backend;

/**
 * User Preferences system.
 * @since 0.00.003
 */
class UPrefs {
    #if(html5)
        /**
         * HTML5 EXCLUSIVE VARIABLE
         * * Contains the save data for the program
         * @since 0.00.006
         */
        public static var prefsData:SharedObject = SharedObject.getLocal("abodePrefs");
    #end
    /**
     * Default Preferences
     * * These get written to the UPrefs file if the file isnt found.
     * @since 0.00.003
     */
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



    /**
     * Return a target preference
     * @param a What we what to try to find
     * @param <T> (HTML5 ONLY) Used for casting.
     * @since 0.00.003
     */
    public static function getFromFile #if(html5)<T>#end(a:String):#if(sys)Dynamic#else T#end{
        #if(sys)
            var v:Dynamic = Reflect.getProperty(Json.parse(getPrefsFile()), a); //inital json data.
            if(v!=null&&Type.typeof(v)==TObject) { //map fix, so maps can be parsed correctly cuz apparently casting is stupid.
                var m = new Map<Dynamic, Dynamic>();
                for(f in Reflect.fields(v)) m.set(f, Reflect.field(v, f));
                return m;
            }
            return v;
        #else
            return (Reflect.field(prefsData.data, a):T);
        #end
    }
    /**
     * Write to preferences
     * @param a key
     * @param b value
     * @return Dynamic returns whatever `b` was
     * @since 0.00.003
     */
    public static function writeToFile(a:String, b:Dynamic):Dynamic {
        #if(sys)
            var json:Dynamic = Json.parse(getPrefsFile());
            Reflect.setField(json, a, b);
            trace('Setting field $a to $b in UPrefs.');
            File.saveContent("uPrefs.json", Json.stringify(json, null,"    "));
        #else
            Reflect.setField(prefsData.data, a, b);
            prefsData.flush();
            trace('Tried to set "$a" to "$b" in SharedObject, returned ${Reflect.getProperty(prefsData.data, a)}');
        #end
        return b;
    }

    #if(sys)
        /**
         * Returns the preferences file, and makes it if it doesnt exist (SYS ONLY)
         * @return String json file
         */
        public static inline function getPrefsFile():String return (FileSystem.exists("uPrefs.json"))?File.getContent("uPrefs.json"):makePrefsFile();

        /**
         * Makes the preferences file (SYS ONLY)
         * @return String the content of the file
         * @since 0.00.003
         */
        public static function makePrefsFile():String {
            File.saveContent("uPrefs.json", Json.stringify(DEFAULT_PREFERENCES, null, "    "));
            return File.getContent("uPrefs.json");
        }
    #else
        /**
         * Make the preferences Object (HTML5 ONLY)
         * @since 0.00.006
         */
        public static function makePrefsFile() {
            for(key=>value in (DEFAULT_PREFERENCES:DynamicAccess<Dynamic>)){
                Reflect.setField(prefsData.data, key, value); //flush after each key.
                prefsData.flush();
            }
            trace('Prefs sent to cookies!');
        }
    #end
}

/**
 * Preference container class
 * @param <T> Type.
 * @since 0.00.003
 */
class Preference<T> {
    /**
     * Name of the preference.
     * Generally used internally.
     * @since 0.00.003
     */
    public var name:String;
    /**
     * Value, this is what the preference is equal to.
     * uses get/set functions to get/set to the file
     * @since 0.00.003
     */
    @:isVar public var value(get, set):T;
    /**
     * returns the value of the preference
     * @return T the preference (Casted to <T>)
     * @since 0.00.003
     */
    public inline function get_value():T return (UPrefs.getFromFile(name):T); //safety
    /**
     * sets the current value to something
     * @return the input
     * @since 0.00.003
     */
    public inline function set_value(a:T):T return UPrefs.writeToFile(name, a);
    /**
     * Initiate a new Preference
     * @param n the name of the preference
     * @param v the value of the preference
     * @since 0.00.003
     */
    public function new(n:String, v:T) {
        name = n;
        @:bypassAccessor value = v;
    }
}