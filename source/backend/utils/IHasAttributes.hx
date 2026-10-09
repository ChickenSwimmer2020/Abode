package backend.utils;

/**
 * Attributes interface for adding attributes to objects.
 * @since 0.1.0
 */
interface IHasAttributes<T1, T2> {
	public var attributes:Map<T1, T2>;
	public function setAttribute(a:T1, b:T2):T1;
	public function getAttribute(a:T1):T2;
	public function removeAttribute(a:T1):Bool;
}

/**
 * Utility functions for Attributes interface
 * @since 0.1.0
 */
class HasAttributesUtil {
	/**
	 * add an attribute to an object
	 * @param object object with attributes
	 * @param key key
	 * @param value value
	 * @return Bool if the attribute set correctly
	 * @since 0.1.0
	 */
	public static inline function setAttribute<T1, T2>(object:Null<IHasAttributes<T1, T2>>, key:T1, value:T2):Null<T1> {
		return object != null ? object.setAttribute(key, value) : null;
	}

	/**
	 * get an attribute from an object
	 * @param object object with attributes
	 * @param key key
	 * @return <T2> attribute value
	 * @since 0.1.0
	 */
	public static inline function getAttribute<T1, T2>(object:Null<IHasAttributes<T1, T2>>, key:T1):Null<T2> {
		return object != null ? object.getAttribute(key) : null;
	}

	/**
	 * remove an attribute from an object
	 * @param object object with attributes
	 * @param key key
	 * @return Bool if the attribute was removed successfully.
	 * @since 0.1.0
	 */
	public static inline function removeAttribute<T1, T2>(object:Null<IHasAttributes<T1, T2>>, key:T1):Bool {
		return object != null ? object.removeAttribute(key) : false;
	}
}
