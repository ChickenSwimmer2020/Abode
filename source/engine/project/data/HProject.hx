package engine.project.data;

/**
 * A Hydro-Frame project.
 * 
 * @since 0.8.0
 */
typedef HProject = {
	/**
	 * The metadata of the project file.
	 * 
	 * @since 0.8.0
	 */
	var meta:HProjectFileMetadata;

	/**
	 * The raw VFS of the project file.
	 * 
	 * @since 0.8.0
	 */
	var raw:HRawProjectFile;
}
