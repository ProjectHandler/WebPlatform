package fr.projecthandler.service;

import java.util.List;

import fr.projecthandler.model.Civility;

public interface CivilityService {
	public Long saveCivility(Civility civility);

	public void updateCivility(Civility civility);

	public void deleteCivilityById(Long civilityId);

	public Civility findCivilityById(Long civilityId);

	public List<Civility> getAllCivilities();
}
