package fr.projecthandler.dao;

import java.util.List;

import fr.projecthandler.model.Address;

public interface AddressDao {

	public Long saveAddress(Address address);

	public void updateAddress(Address address);

	public void deleteAddressById(Long id);

	public Address findAddressById(Long id);

	public List<Address> getAddressesByUser(Long id);

	public void deleteAddressesByIds(List<Long> addressesIdsList);
}
