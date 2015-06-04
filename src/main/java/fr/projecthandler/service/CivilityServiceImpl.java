package fr.projecthandler.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import fr.projecthandler.dao.CivilityDao;
import fr.projecthandler.model.Civility;

@Service
public class CivilityServiceImpl implements CivilityService {

	@Autowired
	CivilityDao civilityDao;

	public Long saveCivility(Civility civility) {
		return civilityDao.saveCivility(civility);
	}

	public void updateCivility(Civility civility) {
		civilityDao.updateCivility(civility);
	}

	public void deleteCivilityById(Long civilityId) {
		civilityDao.deleteCivilityById(civilityId);
	}

	public Civility findCivilityById(Long civilityId) {
		return civilityDao.findCivilityById(civilityId);
	}

	public List<Civility> getAllCivilities() {
		return civilityDao.getAllCivilities();
	}
}
