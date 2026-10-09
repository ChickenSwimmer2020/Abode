package engine.vfs;

import haxe.io.Bytes;

/**
 * A file. Used in `AFileSystem`.
 * 
 * @since 0.8.0
 * @see `AFileSystem`
 */
class HFile extends HFileObj {
	/**
	 * The name of this `HFile`.
	 * 
	 * @since 0.8.0
	 */
	public var name:String;

	/**
	 * The contents of this `HFile`.
	 * 
	 * @since 0.8.0
	 */
	public var contents:Bytes;

	/**
	 * Creates a new `HFile`.
	 * 
	 * @param name The name of this `HFile`.
	 * @param contents The contents of this `HFile`. If null, an empty 0-length
	 * `Bytes` will be used.
	 * 
	 * @since 0.8.0
	 */
	override public function new(name:String, ?contents:Bytes) {
		super();
		this.name = name;
		this.contents = contents != null ? contents : Bytes.alloc(0);
	}
}
