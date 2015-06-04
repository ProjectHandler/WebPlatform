package fr.projecthandler.dao;

import java.util.List;

import fr.projecthandler.model.Civility;

public interface CivilityDao {
	
	public Long saveCivility(Civility civility);

	public void updateCivility(Civility civility);

	public void deleteCivilityById(Long civilityId);

	public Civility findCivilityById(Long civilityId);

	public List<Civility> getAllCivilities();
}