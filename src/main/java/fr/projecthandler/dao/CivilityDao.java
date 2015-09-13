package fr.projecthandler.dao;

import java.util.List;

import fr.projecthandler.model.Civility;

public interface CivilityDao {

	public Civility findCivilityById(Long civilityId);

	public List<Civility> getAllCivilities();
}