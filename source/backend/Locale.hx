package backend;

class Locale { //overrall, very simple system. for now.
    public static var lang:String = "en_US"; //en_US  
    public static function get(key:String, ?replacer:Map<String, Dynamic>, ?overrideLanguage:String):String{
        var target:String = Reflect.getProperty(getLocaleFile(overrideLanguage??lang), key);
        if(target==null) return '[[$key]]';
        else{
            var toReturn:String = target;
            //TODO: fix
            //TODO /*if(Date.now().getMonth()==3&&Date.now().getDate()==1)?*/toReturn = toReturn.replace("abode", "aboat"); 
            if(replacer!=null){
                for(get=>to in replacer){
                    toReturn = toReturn.replace(get, Std.string(to)); //whoops.
                }
                return toReturn; //whoopsies, forgot to do this.
            }else return toReturn;
        }
        return '[[$key]]';
    }
    private static inline function getLocaleFile(t:String):Dynamic return Json.parse(Assets.getText('assets/data/locale/$t.locale')??"{}");
}