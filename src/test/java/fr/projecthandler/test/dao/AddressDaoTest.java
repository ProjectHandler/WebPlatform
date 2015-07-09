package fr.projecthandler.test.dao;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.transaction.TransactionConfiguration;
import org.springframework.transaction.annotation.Transactional;

import fr.projecthandler.dao.AddressDao;
import fr.projecthandler.model.Address;
import fr.projecthandler.model.User;
import fr.projecthandler.service.UserService;
import static org.junit.Assert.*;



@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "/spring/test-config.xml"})
@TransactionConfiguration(defaultRollback = true)
public class AddressDaoTest {
	
	@Autowired
	AddressDao addressDao;
	
	@Autowired
	UserService userService;
	
	String streetName = "Street";
	String streetNumber = "128bis";
	String city = "Paris";
	String zipCode = "75001";
	String country = "France";
	
	private void setAddressData(Address address) {		
		address.setStreetName(streetName);
		address.setStreetNumber(streetNumber);
		address.setCity(city);
		address.setZipCode(zipCode);
		address.setCountry(country);
	}
	
	@Test
	@Transactional
	public void testSaveAddress() {
		Address address = new Address();
		
		setAddressData(address);		
		addressDao.saveAddress(address);
	}
	
	@Test
	@Transactional
	//Test if the saved fields are equal to the loaded fields.
	public void testSaveAndFindAddressById() {
		Address address = new Address();

		setAddressData(address);
		Long id = addressDao.saveAddress(address);
		Address result = addressDao.findAddressById(id);
		assertNotNull("getAddressById: excepted an Address Object but was null", result);
		assertEquals(result.getId(), id);
		assertEquals(result.getStreetName(), streetName);
		assertEquals(result.getStreetNumber(), streetNumber);
		assertEquals(result.getCity(), city);
		assertEquals(result.getZipCode(), zipCode);
		assertEquals(result.getCountry(), country);
	}
	
//	@Test
//	@Transactional
//	public void testGetAddressesByUser() {
//		Address address = new Address();
//
//		List<User> userList = userService.getAllUsers();
//		User user = userList.get(0);
//		setAddressData(address);
//		address.setUser(user);
//		addressDao.saveAddress(address);
//		List<Address> addressList = addressDao.getAddressesByUser(user.getId());
//		assertTrue(addressList.size() == 1);
//	}
	
	@Test
	@Transactional
	public void TestDeleteAddressById() {
		Address address = new Address();

		setAddressData(address);
		Long addressId = addressDao.saveAddress(address);
		addressDao.deleteAddressById(addressId);
		Address result = addressDao.findAddressById(addressId);
		assertNull(result);
	}
}
