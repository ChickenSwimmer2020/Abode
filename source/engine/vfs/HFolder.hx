package engine.vfs;

/**
 * A folder. Used in `AFileSystem`.
 * 
 * @since 0.8.0
 * @see `AFileSystem`
 */
class HFolder extends HFileObj {
	/**
	 * The files that belong to this `HFolder`.
	 * 
	 * @since 0.8.0
	 */
	public var contents:Map<String, HFileObj>;

	/**
	 * Creates a new `HFolder`.
	 * 
	 * @since 0.8.0
	 */
	override public function new() {
		super();
		this.contents = new Map();
	}
}
