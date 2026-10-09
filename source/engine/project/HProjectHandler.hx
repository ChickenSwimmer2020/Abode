package engine.project;

import engine.project.data.HProject;
import engine.project.data.HProjectFileMetadata;
import engine.project.data.HProjectValidationResult;
import engine.project.data.HRawProjectFile;
import engine.utils.HProjectUtils;

/**
 * A class for handling Hydro-Frame projects. Use this for
 * easier interfacing with Hydro-Frame projects.
 * 
 * @since 0.8.0
 */
class HProjectHandler {
	/**
	 * The `HProject` which belongs to this `HProjectHandler`.
	 * 
	 * @since 0.8.0
	 */
	public var project:HProject;

	/**
	 * Whether the project is valid or not.
	 * 
	 * @since 0.8.0
	 */
	public var invalid(get, never):Bool;

	function get_invalid():Bool
		return validate() != HProjectValidationResult.VALID;

	/**
	 * The metadata of this project.
	 * This will throw on set if the project is invalid.
	 * When you set `meta`, it automatically flushes it
	 * via `flushMeta()`.
	 * 
	 * @see `flushMeta()`
	 * @since 0.8.0
	 */
	public var meta(get, set):HProjectFileMetadata;

	private function get_meta():HProjectFileMetadata
		return project?.meta;

	private function set_meta(newMeta:HProjectFileMetadata):HProjectFileMetadata {
		if (invalid) {
			trace("Can't set the metadata of an invalid Hydro-Frame project. A hard revalidation is required.");
			validate(true);
		}
		project.meta = newMeta;
		flushMeta();
		return newMeta;
	}

	/**
	 * The raw VFS of this project.
	 * This will throw on set if the project is invalid.
	 * 
	 * @since 0.8.0
	 */
	public var rawProject(get, set):HRawProjectFile;

	private function get_rawProject():HRawProjectFile
		return project?.raw;

	private function set_rawProject(newRaw:HRawProjectFile):HRawProjectFile {
		if (invalid) {
			trace("Can't set the raw VFS of an invalid Hydro-Frame project. A hard revalidation is required.");
			validate(true);
		}
		project.raw = newRaw;
		if (invalid) {
			trace('New VFS has invalidated the Hydro-Frame project. A hard revalidation is required.');
			validate(true);
		}
		return newRaw;
	}

	/**
	 * Creates a new `HProjectHandler`.
	 * 
	 * @param project The `HProject` which belongs to this `HProjectHandler`.
	 * @param validate If `true`, the `HProject` will be hard-validated. Optional, defaults to `false`.
	 * @since 0.8.0
	 */
	public function new(project:HProject, ?validate:Bool = false) {
		this.project = project;
		if (validate)
			this.validate(true);
	}

	/**
	 * Saves the metadata of this project. Call this any time you
	 * edit `meta` in-place without setting it directly.
	 * 
	 * This gets called automatically when you set `meta`.
	 * 
	 * @see `flushMeta()`
	 * @since 0.8.0
	 */
	public function flushMeta() {
		if (invalid) {
			trace("Can't flush the metadata of an invalid Hydro-Frame project. A hard revalidation is required.");
			validate(true);
		}
		project?.raw?.saveContent('meta.json', Json.stringify(project?.meta, null, '  '));
		if (invalid) {
			trace('Flushed metadata has invalidated the Hydro-Frame project. A hard revalidation is required.');
			validate(true);
		}
	}

	/**
	 * Validates this project.
	 * 
	 * @param hard If `true`, the validation will throw on failure. Optional, defaults to `false`.
	 * @return `HProjectValidationResult` The validation result.
	 * @since 0.8.0
	 */
	public function validate(?hard:Bool = false):HProjectValidationResult
		return HProjectUtils.validate(project, hard);
}
