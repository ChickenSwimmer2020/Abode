package backend.utils;

/**
 * Interface for making sure that something is destroyable
 * EG: has the destroy function.
 * @since 0.2.0
 */
interface IDestroyable {
	/**
	 * destroys the object
	 * @since 0.2.0
	 */
	public function destroy():Void;
}

/**
 * utility for destroying objects
 * @since 0.2.0
 */
class IDestroyableUtil {
	/**
	 * destroy an object
	 * @param object object to destroy
	 * @return T returns null
	 * @since 0.2.0
	 */
	public static function destroy<T:IDestroyable>(object:Null<IDestroyable>):T {
		if (object != null)
			object.destroy();
		return null;
	}
}
