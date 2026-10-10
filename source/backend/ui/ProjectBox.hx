package backend.ui;

class ProjectBox extends HSprite {
	public static final SIZE:HPoint = new HPoint(300, 75);

	public var icon:HSprite;
	public var title:HText;
	public var lastUsed:HText;
	public var size:HText;
	public var desc:HText;

	public function new(x:Float, y:Float) {
		super(x, y);

		makeGraphic(SIZE.iX, SIZE.iY, HColor.RED);

		title = new HText(0 + SIZE.y, 0, width, "[project].(apf/fla)", 12);
		title.setFieldSize(-1, height);
		addChild(title);

		size = new HText(0, 0, width, "---.--- (KB/MB/GB)", 12); // why will we support gb? idfk lmfao.
		size.setFieldSize(-1, height);
		size.x = SIZE.x - (size.textWidth + 5);
		addChild(size);

		lastUsed = new HText(0 + SIZE.y, 0 + title.textHeight, width, "[yesterday, [last | week/month/year], ~ /days/weeks/months/years | ago]", 12);
		lastUsed.setFieldSize(-1, height - title.textHeight);
		addChild(lastUsed);

		desc = new HText(0 + SIZE.y, 0, width, "Description go brrrr", 12);
		desc.setFieldSize(-1, height);
		desc.y = SIZE.y - (desc.textHeight + 5);
		addChild(desc);
	}

	public function loadData(name:String, type:String, lastModded:String, ?description:String) {
		title.text = '$name.${type == "Flash" ? "Fla" : "HFPF"}';
		if (type == "Flash") {
			title.textColor = HColor.WHITE;
			lastUsed.textColor = HColor.WHITE;
		}
		lastUsed.text = lastModded;
		desc.text = description ?? ""; // show nothing if its null.

		makeGraphic(gWidth, gHeight, type == "Flash" ? 0xFF1b1b1b : 0xFF5a5a5a); // FF1b1b1b is fron animate directly, thanks Windows+shift+c!
		switch (type) { // graphic, *then* icon.
			case "Flash":
				DrawUtil.drawIcon(this, "FILE_FLASH", 1, 0xFF9999FF, 0xFF00005B);
			case "HFPF":
				DrawUtil.drawIcon(this, "FILE_HFPF", 1, 0xFF9173B5, 0xFF89B2B7);
		}
	}
}
