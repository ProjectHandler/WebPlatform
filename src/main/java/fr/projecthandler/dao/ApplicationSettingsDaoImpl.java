package fr.projecthandler.dao;

import java.util.LinkedHashSet;
import java.util.Set;

import org.springframework.stereotype.Component;

import fr.projecthandler.model.ApplicationSetting;
import fr.projecthandler.util.Utilities;

@Component
public class ApplicationSettingsDaoImpl extends AbstractDao implements ApplicationSettingsDao {

	@Override
	public void updateApplicationSetting(ApplicationSetting appSetting) {
		em.merge(appSetting);
	}

	@Override
	public ApplicationSetting findApplicationSettingById(Long appSettingId) {
		return (ApplicationSetting) Utilities.getSingleResultOrNull(em.createQuery("SELECT as FROM ApplicationSetting as WHERE as.id = :appSettingId")
				.setParameter("appSettingId", appSettingId));
	}

	@Override
	public Set<ApplicationSetting> getAllApplicationSettings() {
		LinkedHashSet<ApplicationSetting> result = new LinkedHashSet<ApplicationSetting>();
		result.addAll(em.createQuery("SELECT * FROM ApplicationSetting as").getResultList());
		return result;
	}

	@Override
	public ApplicationSetting findApplicationSettingByKey(String key) {
		return (ApplicationSetting) Utilities.getSingleResultOrNull(em.createQuery("SELECT as FROM ApplicationSetting as WHERE as.key = :key")
				.setParameter("key", key));
	}

}
