package fr.projecthandler.service;

import java.util.List;

import fr.projecthandler.model.Civility;

public interface CivilityService {

	public Civility findCivilityById(Long civilityId);

	public List<Civility> getAllCivilities();
}
