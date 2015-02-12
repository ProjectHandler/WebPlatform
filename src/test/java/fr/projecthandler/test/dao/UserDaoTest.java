package fr.projecthandler.test.dao;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.transaction.TransactionConfiguration;
import org.springframework.transaction.annotation.Transactional;

import fr.projecthandler.dao.UserDao;
import fr.projecthandler.enums.AccountStatus;
import fr.projecthandler.enums.Civility;
import fr.projecthandler.enums.UserRole;
import fr.projecthandler.model.Group;
import fr.projecthandler.model.User;
import fr.projecthandler.service.UserService;
import static org.junit.Assert.*;



@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "/spring/test-config.xml"})
@TransactionConfiguration(defaultRollback = true)
public class UserDaoTest {
	
	@Autowired
	UserDao userDao;

	private Civility civility = Civility.M;
	private String firstName = "Robert";
	private String lastName = "Dupont";
	private String password = "56az4de456zaz";
	private UserRole userRole = UserRole.ROLE_SIMPLE_USER;
	//private Set<Address> address;
	private String email = "robert.dupont478@yopmail.com";
	private String phone = "0142215886";
	private String mobilePhone = "0654422187";
	private AccountStatus accountStatus = AccountStatus.ACTIVE;
	//private List<Group> groups;

	private void setUserData(User user) {
		user.setCivility(civility);
		user.setFirstName(firstName);
		user.setLastName(lastName);
		user.setPassword(password);
		user.setUserRole(userRole);
		user.setEmail(email);
		user.setPhone(phone);
		user.setMobilePhone(mobilePhone);
		user.setAccountStatus(accountStatus);
	}
	
	@Test
	@Transactional
	public void testSaveUser() {
		User user = new User();
		
		setUserData(user);		
		userDao.saveUser(user);
	}
	
	@Test
	@Transactional
	//Test if the saved fields are equal to the loaded fields.
	public void testSaveAndFindUserById() {
		User user = new User();

		setUserData(user);
		Long id = userDao.saveUser(user);
		User result = userDao.findUserById(id);
		assertNotNull("getUserById: excepted a User Object but was null", result);
		assertEquals(result.getId(), id);
		assertEquals(result.getFirstName(), firstName);
		assertEquals(result.getLastName(), lastName);
		assertEquals(result.getPassword(), password);
		assertEquals(result.getUserRole(), userRole);
		assertEquals(result.getEmail(), email);
		assertEquals(result.getPhone(), phone);
		assertEquals(result.getMobilePhone(), mobilePhone);
		assertEquals(result.getAccountStatus(), accountStatus);
	}
	
	@Test
	@Transactional
	public void testFindByEmail() {
		User user = new User();

		setUserData(user);
		userDao.saveUser(user);
		User result = userDao.findByEmail(email);
		assertEquals(user.getId(), result.getId());
	}
	
	@Test
	@Transactional
	public void testDeleteUserByListIds() {
		List<Long> userIdList = new ArrayList<Long>(); ;
		
		for (int i = 0; i < 10; i++) {
			User user = new User();
			setUserData(user);
			userIdList.add(userDao.saveUser(user));
		}
		
		userDao.deleteUserByListIds(userIdList);
		for (Long userId : userIdList) {
			User result = userDao.findUserById(userId);
			assertNull(result);
		}
	}
}
