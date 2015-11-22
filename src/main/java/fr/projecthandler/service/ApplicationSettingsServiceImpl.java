package fr.projecthandler.service;

import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import fr.projecthandler.dao.ApplicationSettingsDao;
import fr.projecthandler.model.ApplicationSetting;

@Service
public class ApplicationSettingsServiceImpl implements ApplicationSettingsService{

	@Autowired
	ApplicationSettingsDao applicationSettingsDao;

	@Override
	public void updateApplicationSetting(ApplicationSetting appSetting) {
		applicationSettingsDao.updateApplicationSetting(appSetting);
	}

	@Override
	public ApplicationSetting findApplicationSettingById(Long appSettingId) {
		return applicationSettingsDao.findApplicationSettingById(appSettingId);
	}

	@Override
	public Set<ApplicationSetting> getAllApplicationSettings() {
		return applicationSettingsDao.getAllApplicationSettings();
	}

	@Override
	public ApplicationSetting findApplicationSettingByKey(String key) {
		return applicationSettingsDao.findApplicationSettingByKey(key);
	}
}
