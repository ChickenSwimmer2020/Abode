package backend.utils;

/**
 * Array utilities, not currently used for anything.
 * @since 0.1.0
 */
class ArrayUtil {
	/**
	 * Alan, please add details.
	 * @param a array of bools
	 * @return Bool if all in the array are true
	 * @since 0.1.0
	 */
	public static function allTrue(a:Array<Bool>):Bool {
		for (b in a)
			if (!b)
				return false;
		return true;
	}
}
