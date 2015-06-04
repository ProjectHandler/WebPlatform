package fr.projecthandler.dao;

import java.util.List;

import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import fr.projecthandler.model.Civility;
import fr.projecthandler.util.Utilities;

@Component
public class CivilityDaoImpl extends AbstractDao implements CivilityDao {

	@Override
	@Transactional
	public void updateCivility(Civility civility) {
		em.merge(civility);
	}

	@Override
	@Transactional
	public Long saveCivility(Civility civility) {
		em.persist(civility);
		
		return civility.getId();
	}

	@Override
	@Transactional
	public void deleteCivilityById(Long civilityId) {
		em.createQuery("DELETE FROM Civility tt WHERE tt.id = :civilityId")
		.setParameter("civilityId", civilityId)
		.executeUpdate();
	}
	@Override
	public Civility findCivilityById(Long civilityId) {
		return (Civility) Utilities.getSingleResultOrNull(em.createQuery("SELECT tt FROM Civility tt WHERE tt.id = :civilityId")
				.setParameter("civilityId", civilityId));
	}

	@Override
	public List<Civility> getAllCivilities() {
		return (List<Civility>)em.createQuery("SELECT tt FROM Civility tt")
				.getResultList();
	}

}