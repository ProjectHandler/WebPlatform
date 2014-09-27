package fr.projecthandler.dao;

import java.util.List;

import fr.projecthandler.model.Address;

public interface AddressDao {

	public void save(Address address);

	public Address getAddressById(Long id);
	
	public List<Address> getAddressByUser(Long id);

	public void updateAddress(Address address);

	public void deleteAddressById(Long id);
	
	public void deleteAddressByListIds(List<Long> addressesIdsList);
}
