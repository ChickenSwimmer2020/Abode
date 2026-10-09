package engine.project.data;

/**
 * The metadata of a Hydro-Frame project file.
 * This is just the parsed json data of the projects root metadata file(`meta.json`).
 * 
 * @since 0.8.0
 */
typedef HProjectFileMetadata = {
	/**
	 * The name of the project file.
	 * 
	 * @since 0.8.0
	 */
	var name:String;

	/**
	 * The version of the project file.
	 * 
	 * @since 0.8.0
	 */
	var version:String;

	/**
	 * The authors of the project file. Optional.
	 * 
	 * @since 0.8.0
	 */
	var ?authors:Array<String>;
}
