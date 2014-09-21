package fr.projecthandler.dao;

import fr.projecthandler.model.Address;

public interface AddressDao {

	public void save(Address address);

	public Address getAddressById(Long id);

	public void updateAddress(Address address);

	public void deleteAddressById(Long id);
}
