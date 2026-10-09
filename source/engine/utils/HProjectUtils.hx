package engine.utils;

import engine.project.data.HProject;
import engine.project.data.HProjectValidationResult;
import engine.project.data.HRawProjectFile;

class HProjectUtils {
	/**
	 * Validates the `HRawProjectFile`.
	 * 
	 * @param project The `HRawProjectFile` to validate.
	 * @param hard If `true`, the validation will throw on failure. Optional, defaults to `false`.
	 * @return `HProjectValidationResult` The validation result.
	 * @since 0.8.0
	 */
	public static function validateRaw(project:HRawProjectFile, ?hard:Bool = false):HProjectValidationResult {
		var validationChecks = [
			{
				cond: project == null,
				res: NULL_PROJECT
			},
			{
				cond: !project?.fileExists('meta.json'),
				res: NO_META
			}
		];

		for (check in validationChecks) {
			if (check.cond) {
				if (hard)
					throw 'Hydro-Frame project validation failure: ${check.res}';
				return check.res;
			}
		}

		return VALID;
	}

	/**
	 * Validates the `HProject`. Uses `validateRaw()` under the hood.
	 * 
	 * @param project The `HProject` to validate.
	 * @param hard If `true`, the validation will throw on failure. Optional, defaults to `false`.
	 * @return `HProjectValidationResult` The validation result.
	 * @see `validateRaw()`
	 * @since 0.8.0
	 */
	public static function validate(project:HProject, ?hard:Bool = false):HProjectValidationResult
		return validateRaw(project.raw, hard);
}
