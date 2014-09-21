package fr.projecthandler.dao;


import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import fr.projecthandler.Util.Utilities;
import fr.projecthandler.model.Address;

@Component
public class AddressDaoImpl extends AbstractDao implements AddressDao {

	@Override
	@Transactional
	public void save(Address address) {
		this.em.persist(address);
	}

	@Override
	public Address getAddressById(Long id) {
		return (Address) Utilities.getSingleResultOrNull(
				em.createQuery("FROM Address a WHERE a.id =:id").setParameter("id", id));
	}

	@Override
	@Transactional
	public void updateAddress(Address address) {
		em.merge(address);
	}

	@Override
	public void deleteAddressById(Long id) {
		em.createQuery("DELETE FROM Address c WHERE c.id =:id").setParameter("id", id).executeUpdate();
	}
	
}
