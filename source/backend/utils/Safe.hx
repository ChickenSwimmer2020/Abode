package backend.utils;

@:dox(hide) @:noCompletion class Safe {
	@:dox(hide) @:noCompletion public static function run(fn:Void->Void, ?label:String):Void {
		while (true) {
			try {
				fn();
				return;
			} catch (e:Exception) {
				var res = Main.showCrash(e.message, e.stack);
				switch (res) {
					case 0:
						Sys.exit(1);
					case 1:
						continue;
					case 2:
						return;
				}
			}
		}
	}

	@:dox(hide) @:noCompletion public static function runR<T>(fn:Void->T, fallback:T, ?label:String):T {
		while (true) {
			try {
				return fn();
			} catch (e:Exception) {
				var res = Main.showCrash(e.message, e.stack);
				switch (res) {
					case 0:
						Sys.exit(1);
					case 1:
						continue;
					case 2:
						return fallback;
				}
			}
		}
	}
}
