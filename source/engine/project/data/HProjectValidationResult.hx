package engine.project.data;

/**
 * The validation result of a Hydro-Frame project.
 * 
 * @since 0.8.0
 */
enum abstract HProjectValidationResult(String) from String to String {
	/**
	 * A valid Hydro-Frame project.
	 * 
	 * @since 0.8.0
	 */
	var VALID = 'Valid project.';

	/**
	 * No metadata was found in the Hydro-Frame project file VFS.
	 * 
	 * @since 0.8.0
	 */
	var NO_META = 'No metadata was found.';

	/**
	 * The Hydro-Frame project file passed into the validator was null.
	 * 
	 * @since 0.8.0
	 */
	var NULL_PROJECT = 'Null project.';
}
