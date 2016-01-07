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
import static org.junit.Assert.assertEquals;

import fr.projecthandler.dao.GroupDao;
import fr.projecthandler.dao.UserDao;
import fr.projecthandler.model.Group;
import fr.projecthandler.model.User;
import fr.projecthandler.test.content.DataProvider;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "/spring/test-config.xml"})
@TransactionConfiguration(defaultRollback = true)
public class GroupDaoTest {
	@Autowired
	GroupDao groupDao;
	
	@Autowired
	UserDao userDao;

	@Test
	@Transactional
	public void testGetAllGroups() {
		Group g1 = DataProvider.getGroup1Data();
		Group g2 = DataProvider.getGroup2Data();
		Group g3 = DataProvider.getGroup3Data();

		User u1 = DataProvider.getUser1Data();
		User u2 = DataProvider.getUser2Data();
		User u3 = DataProvider.getUser3Data();
		
		Long idTmp = userDao.saveUser(u1);
		u1 = userDao.findUserById(idTmp);
		idTmp = userDao.saveUser(u2);
		u2 = userDao.findUserById(idTmp);
		idTmp = userDao.saveUser(u3);
		u3 = userDao.findUserById(idTmp);
		
		List<User> g1Users = new ArrayList<>();
		List<User> g2Users = new ArrayList<>();
		List<User> g3Users = new ArrayList<>();
		
		g1Users.add(u1);
		g1Users.add(u2);
		g2Users.add(u3);
		
		g1.setUsers(g1Users);
		g2.setUsers(g2Users);
		g3.setUsers(g3Users);
		
		idTmp = groupDao.saveGroup(g1);
		g1 = groupDao.findGroupById(idTmp);
		idTmp = groupDao.saveGroup(g2);
		g2 = groupDao.findGroupById(idTmp);
		idTmp = groupDao.saveGroup(g3);
		g3 = groupDao.findGroupById(idTmp);
		
		// general tests
		assertEquals(g1Users.size(), g1.getUsers().size());
		assertEquals("Groupe 1", g1.getName());
		assertEquals(g2Users.size(), g2.getUsers().size());
		assertEquals("Groupe 2", g2.getName());
		assertEquals(g3Users.size(), g3.getUsers().size());
		assertEquals("Groupe 3", g3.getName());

		// getAllGroups tests
		List<Group> gList = groupDao.getAllGroups();
		List<String> gNameList = new ArrayList<>();
		for (Group g : gList)
			gNameList.add(g.getName());
		assertEquals(true, gNameList.contains("Groupe 1"));
		assertEquals(true, gNameList.contains("Groupe 2"));
		assertEquals(true, gNameList.contains("Groupe 3"));
	}

	@Test
	@Transactional
	public void testGetAllNonEmptyGroups() {
		Group g1 = DataProvider.getGroup1Data();
		Group g2 = DataProvider.getGroup2Data();
		Group g3 = DataProvider.getGroup3Data();

		User u1 = DataProvider.getUser1Data();
		User u2 = DataProvider.getUser2Data();
		User u3 = DataProvider.getUser3Data();
		
		Long idTmp = userDao.saveUser(u1);
		u1 = userDao.findUserById(idTmp);
		idTmp = userDao.saveUser(u2);
		u2 = userDao.findUserById(idTmp);
		idTmp = userDao.saveUser(u3);
		u3 = userDao.findUserById(idTmp);
		
		List<User> g1Users = new ArrayList<>();
		List<User> g2Users = new ArrayList<>();
		List<User> g3Users = new ArrayList<>();
		
		g1Users.add(u1);
		g1Users.add(u2);
		g2Users.add(u3);
		
		g1.setUsers(g1Users);
		g2.setUsers(g2Users);
		g3.setUsers(g3Users);
		
		idTmp = groupDao.saveGroup(g1);
		g1 = groupDao.findGroupById(idTmp);
		idTmp = groupDao.saveGroup(g2);
		g2 = groupDao.findGroupById(idTmp);
		idTmp = groupDao.saveGroup(g3);
		g3 = groupDao.findGroupById(idTmp);
		
		List<Group> gList = groupDao.getAllNonEmptyGroups();
		List<String> gNameList = new ArrayList<>();
		for (Group g : gList)
			gNameList.add(g.getName());
		assertEquals(true, gNameList.contains("Groupe 1"));
		assertEquals(true, gNameList.contains("Groupe 2"));
		assertEquals(false, gNameList.contains("Groupe 3"));
	}

	@Test
	@Transactional
	public void testFindGroupByName() {
		Group g1 = DataProvider.getGroup1Data();
		
		Long idTmp = groupDao.saveGroup(g1);
		g1 = groupDao.findGroupById(idTmp);
		
		Group gFound = groupDao.findGroupByName(g1.getName());
		assertEquals(idTmp, gFound.getId());
		assertEquals(g1.getName(), gFound.getName());
	}

	@Test
	@Transactional
	public void testGetGroupUsersByGroupId() {
		Group g1 = DataProvider.getGroup1Data();

		User u1 = DataProvider.getUser1Data();
		User u2 = DataProvider.getUser2Data();
		User u3 = DataProvider.getUser3Data();
		
		Long idTmp = userDao.saveUser(u1);
		u1 = userDao.findUserById(idTmp);
		idTmp = userDao.saveUser(u2);
		u2 = userDao.findUserById(idTmp);
		idTmp = userDao.saveUser(u3);
		u3 = userDao.findUserById(idTmp);
		
		List<User> g1Users = new ArrayList<>();
		
		g1Users.add(u1);
		g1Users.add(u3);

		g1.setUsers(g1Users);
		
		idTmp = groupDao.saveGroup(g1);
		
		List<User> usersFound = groupDao.getGroupUsersByGroupId(idTmp);
		assertEquals(true, usersFound.contains(u1));
		assertEquals(false, usersFound.contains(u2));
		assertEquals(true, usersFound.contains(u3));
	}
}
