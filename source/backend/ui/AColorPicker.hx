package backend.ui;

class AColorPicker extends ASprite {
    var previewColor:ASprite;
    public function new(x:Float, y:Float, width:Float, height:Float){
        super(x, y);

        previewColor = new ASprite(0, 0).makeGraphic(width.floor(), height.floor(), AColor.WHITE);
        addChild(previewColor);
    }
}