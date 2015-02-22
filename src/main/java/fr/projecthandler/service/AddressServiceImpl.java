package fr.projecthandler.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import fr.projecthandler.dao.AddressDao;
import fr.projecthandler.model.Address;

@Service
public class AddressServiceImpl implements AddressService {
	
	@Autowired
	AddressDao addressDao;

	@Override
	public void saveAddress(Address newAddress) {
		addressDao.saveAddress(newAddress);
	}

	@Override
	public void deleteAddressesByIds(List<Long> addressesIdsList) {
		addressDao.deleteAddressesByIds(addressesIdsList);
	}
	
	@Override
	public void updateAddress(Address a) {
		addressDao.updateAddress(a);
	}

	@Override
	public List<Address> getAddressesByUser(Long id) {
		return addressDao.getAddressesByUser(id);
	}
	
}
