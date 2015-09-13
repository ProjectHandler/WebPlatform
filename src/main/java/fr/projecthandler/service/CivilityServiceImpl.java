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

	public Civility findCivilityById(Long civilityId) {
		return civilityDao.findCivilityById(civilityId);
	}

	public List<Civility> getAllCivilities() {
		return civilityDao.getAllCivilities();
	}
}
