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
	public Long saveAddress(Address address) {
		em.persist(address);
		
		return address.getId();
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
	public Address findAddressById(Long id) {
		return (Address) Utilities.getSingleResultOrNull(
				em.createQuery("FROM Address a WHERE a.id =:id").setParameter("id", id));
	}

	@Override
	public List<Address> getAddressesByUser(Long userId) {
		return (List<Address>)em.createQuery("FROM Address a WHERE a.user.id = :userId")
				.setParameter("userId", userId).getResultList();
	}

	@Override
	@Transactional
	public void deleteAddressByIds(List<Long> addressesIdsList) {
		em.createQuery("DELETE FROM Address a WHERE a.id IN :addressesIdsList")
		.setParameter("addressesIdsList", addressesIdsList).executeUpdate();
	}
	
}
