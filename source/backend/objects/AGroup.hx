package backend.objects;

/**
 * group extending ASprite
 * @since 0.00.002
 */
class AGroup<T:ASprite> extends ASprite {
	/**
	 * members of the group
	 * @since 0.00.002
	 */
	public var members:Array<T>;

	/**
	 * maximum size of the group
	 * @since 0.00.002
	 */
	public var maxSize(default, set):Int = -1;

	public function set_maxSize(a:Int):Int {
		maxSize = a;
		return a;
	}

	/**
	 * make a new group
	 * @param x x position
	 * @param y y position
	 * @param maxSize maximum size (optional)
	 * @since 0.00.002
	 */
	public function new(x:Float, y:Float, ?maxSize:Int) {
		super(x, y);
		members = []; // initiate.
		if (maxSize != null) {
			members.resize(maxSize);
			this.maxSize = maxSize;
		}
	}

	/**
	 * Add a T to the group
	 * @param a object to add
	 * @return T object that was added
	 * @since 0.00.002
	 */
	public function add(a:T):T {
		if (maxSize == -1 || members.length < maxSize) {
			members.push(a);
			addChild(a);
		} else {
			trace('Couldnt add, group is full!');
		}
		return a;
	}

	/**
	 * remove an object from the group
	 * @param a object to remove
	 * @return Bool was it removed
	 * @since 0.00.002
	 */
	public function remove(a:T):Bool {
		if (members.indexOf(a) == -1) {
			trace('Couldnt remove $a from the group, its not in members!');
			return false;
		}
		var b = members.remove(a);
		removeChild(a);
		return b;
	}

	/**
	 * destroy the group and every object in it
	 * @since 0.00.002
	 */
	override public function destroy() {
		for (member in members) {
			switch (Type.getClass(member)) {
				case ASprite:
					members.remove(member);
					removeChild(member);
					cast(member, ASprite).destroy();
				case AButton:
					members.remove(member);
					removeChild(member);
					cast(member, AButton).destroy();
				case AGroup:
					members.remove(member);
					removeChild(member);
					cast(member, AGroup<Dynamic>).destroy();
				case AText:
					members.remove(member);
					removeChild(member);
					cast(member, AText).destroy();
				default:
					trace('Unknown class: ${Type.getClass(member)}');
			}
		}
		members = [];
		if (parent != null)
			parent.removeChild(this);
		super.destroy();
	}
}
