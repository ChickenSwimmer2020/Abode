package backend.engine.vfs;

import haxe.io.Bytes;

/**
 * A file. Used in `AFileSystem`.
 * 
 * @since 0.00.008
 * @see `AFileSystem`
 */
class AFile extends AFileObj {
	/**
	 * The name of this `AFile`.
	 * 
	 * @since 0.00.008
	 */
	public var name:String;

	/**
	 * The contents of this `AFile`.
	 * 
	 * @since 0.00.008
	 */
	public var contents:Bytes;

	/**
	 * Creates a new `AFile`.
	 * 
	 * @param name The name of this `AFile`.
	 * @param contents The contents of this `AFile`. If null, an empty 0-length
	 * `Bytes` will be used.
	 * 
	 * @since 0.00.008
	 */
	override public function new(name:String, ?contents:Bytes) {
		super();
		this.name = name;
		this.contents = contents != null ? contents : Bytes.alloc(0);
	}
}
