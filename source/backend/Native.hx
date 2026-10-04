package backend;

#if(windows)
    @:headerCode("#pragma comment(lib, \"dwmapi.lib\")
    ")

    @:cppFileCode('
        #include <windows.h>
        #include <dwmapi.h>
        #pragma comment(lib, "dwmapi.lib")

        static int getAccentNative() {
            DWORD color = 0;
            BOOL opaque = FALSE;
            if (FAILED(DwmGetColorizationColor(&color, &opaque)))
                return 0;
            return (int)color;
        }
')
#end
class Native {
    public static inline function flashTaskbar() {
        #if(windows)
            trace("flashTaskbar: Not Implemented");
        #elseif linux
            trace("flashTaskbar: Not Implemented");
        #elseif(html5||android)
            trace("flashTaskbar: Unsupported!");
        #end
    }

    public static function getAccentColor():AColor {
        #if(windows)
            var returned:Int = untyped __cpp__("getAccentNative();");
            if(returned==0) return 0xFF000000;
            var toReturn:AColor = AColor.fromInt(returned);
            toReturn.a = 1.0;
            return toReturn;
        #elseif linux
            var env:String = getDesktopEnv();
            trace('HEY, MINT: SEND THIS LINE BACK TO ME!! "DesktopEnv is: $env"');
            switch(env) {
                default: return AColor.BUTTON_IDLE;
            }
        #elseif(html5||android) trace("getAccentColor: Unsupported!"); #end
        return AColor.BUTTON_IDLE; //fallback
    }
    #if linux
        private static function getDesktopEnv():String {
            var desktop:String = "FALLBACK";
            final env=Sys.environment();
            desktop = env.get("XDG_CURRENT_DESKTOP");
            if(desktop==null||desktop=="") desktop = env.get("DESKTOP_SESSION"); //secondary fallback check
            if(desktop==null||desktop=="") return "FALLBACK"; //second check.
            return desktop;
        }
    #end
}