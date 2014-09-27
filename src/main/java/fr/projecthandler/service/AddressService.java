package fr.projecthandler.service;

import java.util.List;

import fr.projecthandler.model.Address;

public interface AddressService {
	
	public void saveAddress(Address newAddress);
	
	public List<Address> getAddressByUser(Long id);
	
	public void updateAddress(Address a);
	
	public void deleteAddressByIds(List<Long> addressesIdsList);
}
