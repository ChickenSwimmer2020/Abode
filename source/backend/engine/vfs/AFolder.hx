package backend.engine.vfs;

/**
 * A folder. Used in `AFileSystem`.
 * 
 * @since 0.00.008
 * @see `AFileSystem`
 */
class AFolder extends AFileObj {
	public var contents:Map<String, AFileObj>;

	override public function new() {
		super();
		this.contents = new Map();
	}
}
