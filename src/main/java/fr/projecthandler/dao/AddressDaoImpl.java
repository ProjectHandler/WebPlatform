package fr.projecthandler.dao;


import java.util.List;

import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import fr.projecthandler.model.Address;
import fr.projecthandler.util.Utilities;

@Component
public class AddressDaoImpl extends AbstractDao implements AddressDao {

	@Override
	@Transactional
	public void save(Address address) {
		em.persist(address);
	}

	@Override
	public Address getAddressById(Long id) {
		return (Address) Utilities.getSingleResultOrNull(
				em.createQuery("FROM Address a WHERE a.id =:id").setParameter("id", id));
	}

	@Override
	public List<Address> getAddressByUser(Long userId) {
		return (List<Address>)em.createQuery("FROM Address a WHERE a.user.id = :userId")
				.setParameter("userId", userId).getResultList();
	}

	@Override
	@Transactional
	public void updateAddress(Address address) {
		em.merge(address);
	}

	@Override
	public void deleteAddressById(Long id) {
		em.createQuery("DELETE FROM Address a WHERE a.id =:id").setParameter("id", id).executeUpdate();
	}

	@Override
	@Transactional
	public void deleteAddressByListIds(List<Long> addressesIdsList) {
		em.createQuery("DELETE FROM Address a WHERE a.id IN :addressesIdsList")
		.setParameter("addressesIdsList", addressesIdsList).executeUpdate();
	}
	
}
