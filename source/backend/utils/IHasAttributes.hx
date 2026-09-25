package backend.utils;

interface IHasAttributes<T1, T2> {
    public var attributes:Map<T1, T2>;
    public function setAttribute(a:T1, b:T2):T1;
	public function getAttribute(a:T1):T2;
    public function removeAttribute(a:T1):Bool;
}

class HasParamsUtil {
	public static inline function setAttribute<T1, T2>(object:Null<IHasAttributes<T1, T2>>, key:T1, value:T2):Null<T1> {
		return object != null ? object.setAttribute(key, value) : null;
	}

	public static inline function getAttribute<T1, T2>(object:Null<IHasAttributes<T1, T2>>, key:T1):Null<T2> {
		return object != null ? object.getAttribute(key) : null;
	}

	public static inline function removeAttribute<T1, T2>(object:Null<IHasAttributes<T1, T2>>, key:T1):Bool {
		return object != null ? object.removeAttribute(key) : false;
	}
}