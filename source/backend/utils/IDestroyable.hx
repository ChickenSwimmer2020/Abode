package backend.utils;

interface IDestroyable {
    public function destroy():Void;
}

class IDestroyableUtil {
	public static function destroy<T:IDestroyable>(object:Null<IDestroyable>):T {
		if (object != null) object.destroy();
		return null;
	}
}