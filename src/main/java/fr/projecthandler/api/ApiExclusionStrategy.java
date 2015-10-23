package fr.projecthandler.api;

import com.google.gson.ExclusionStrategy;
import com.google.gson.FieldAttributes;

import fr.projecthandler.annotation.ApiExclude;

/**
 * This class defines custom exclusion policy. We want to ignore all fields that have been annotated with the ApiExclude annotation. Note that we can
 * also ignore fields based on name or type. This same policy can be applied to any class.
 *
 */
public class ApiExclusionStrategy implements ExclusionStrategy {

	public ApiExclusionStrategy() {
	}

	// This method is called for all fields. if the method returns false the
	// field is excluded from serialization
	@Override
	public boolean shouldSkipField(FieldAttributes f) {
		if (f.getAnnotation(ApiExclude.class) == null) {
			return false;
		}

		return true;
	}

	// This method is called for all classes. If the method returns false the
	// class is excluded.
	@Override
	public boolean shouldSkipClass(Class<?> clazz) {
		return clazz.getAnnotation(ApiExclude.class) != null;
	}
}