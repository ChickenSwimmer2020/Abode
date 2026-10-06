package;

/**
 * The different selectable tools of HYDRO-FRAME!
 * @since 0.00.008
 */
enum Tool {
    SELECTION;
    SUBSELECTION;
    FREE_TRANSFORM;
    GRADIENT_TRANSFORM;
    LASSO;
    POLYGON;
    MAGIC_WAND;
    FLUID_BRUSH;
    CLASSIC_BRUSH;
    ERASOR;
    RECTANGLE;
    RECTANGLE_PRIMITIVE;
    OVAL;
    OVAL_PRIMITIVE;
    POLYSTAR;
    LINE;
    PEN;
    ADD_ANCHOR_POINT;
    DELETE_ANCHOR_POINT;
    CONVERT_ANCHOR_POINT;
    TEXT;
    PAINT_BUCKET;
    INK_BOTTLE;
    EYEDROPPER;
    IMAGE_WARP; //asset_warp
    HAND;
    ROTATION;
    TIME_SCRUB;
    ZOOM;
}
/**
 * Information for saving where tab was stored on the editor UI area.
 * dumps to UPrefs on program close.
 * @since 0.00.008
 */
//TODO: make dump to uPrefs for every tab when HYDRO-FRAME closes.
typedef SavedTabInfo = {
    var name:String;
    var size:Float;
    var position:HPoint;
};
/**
 * The heart of HYDRO-FRAME, the editor!
 * this is where drawing, and animation happen!
 * it is also the most COMPLEX state of all of HYDRO-FRAME.
 * @since 0.00.008
 */
class EditorState extends HState {
    /**
     * the currently selected tool within the editor
     * @since 0.00.008
     */
    public var currentTool:Tool = SELECTION;

    /**
     * This is the window that contains your tools!
     * @since 0.00.008
     */
    public var toolsTabArea:Null<HWindow> = null;

    /**
     * Initilize Editor state with width, height, fps, scripting format, and measurement!
     * @param width stage width
     * @param height stage height
     * @param fps stage fps
     * @param scriptType stage script format
     * @param measureType stage measurement type
     * @since 0.00.008
     */
    public function new(width:Float, height:Float, fps:Int, scriptType:String, measureType:String) {
        super();
        //init the windows.
        makeToolsWindow();


        //other init stuff


        trace('editorstate made with ${width}x$height @$fps, script mode $scriptType, measure mode $measureType');
    }



    private function makeToolsWindow() {
        toolsTabArea = Main.windowManager.makeWindow("Tools", 0, 20, 295, Main.pHeight-20, false, true);


    }
}