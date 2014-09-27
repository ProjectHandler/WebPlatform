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
		addressDao.save(newAddress);
	}

	@Override
	public void deleteAddressByIds(List<Long> addressesIdsList) {
		addressDao.deleteAddressByListIds(addressesIdsList);
	}
	
	@Override
	public void updateAddress(Address a) {
		addressDao.updateAddress(a);
	}

	@Override
	public List<Address> getAddressByUser(Long id) {
		return addressDao.getAddressByUser(id);
	}
	
}
