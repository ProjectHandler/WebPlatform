package fr.projecthandler.service;

import java.util.Set;

import fr.projecthandler.model.ApplicationSetting;

public interface ApplicationSettingsService {
	/*
	 *  Note that there are no save and no delete functions because this
	 *  would not make sense since we absolutely need every settings to
	 *  make the application work.
	 */
	public void updateApplicationSetting(ApplicationSetting appSetting);

	public ApplicationSetting findApplicationSettingById(Long appSettingId);
	
	public Set<ApplicationSetting> getAllApplicationSettings();
	
	public ApplicationSetting findApplicationSettingByKey(String key);
}
