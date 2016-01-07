package fr.projecthandler.test.dao;

import static org.junit.Assert.*;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.transaction.TransactionConfiguration;
import org.springframework.transaction.annotation.Transactional;

import fr.projecthandler.dao.ProjectDao;
import fr.projecthandler.dao.UserDao;
import fr.projecthandler.model.Project;
import fr.projecthandler.model.User;
import fr.projecthandler.test.content.DataProvider;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "/spring/test-config.xml" })
@TransactionConfiguration(defaultRollback = true)
public class ProjectDaoTest {
	@Autowired
	ProjectDao projectDao;

	@Autowired
	UserDao userDao;

	@Test
	@Transactional
	public void testFindProjectByProjectIdAndUserId() {
		User u = DataProvider.getUser1Data();

		Long idTmp = userDao.saveUser(u);
		u = userDao.findUserById(idTmp);

		Project p1 = DataProvider.getProject1Data();
		Project p2 = DataProvider.getProject2Data();

		List<User> p1UsersList = new ArrayList<>();
		p1UsersList.add(u);
		p1.setUsers(p1UsersList);
		idTmp = projectDao.saveProject(p1);
		p1 = projectDao.findProjectById(idTmp);
		idTmp = projectDao.saveProject(p2);
		p2 = projectDao.findProjectById(idTmp);

		Project pFound = projectDao.findProjectByProjectIdAndUserId(u.getId(), p1.getId());
		assertEquals(p1.getName(), pFound.getName());
		assertEquals(p1.getDateBegin(), pFound.getDateBegin());
		assertEquals(p1.getDateEnd(), pFound.getDateEnd());
		assertEquals(p1.getDuration(), pFound.getDuration());
		assertEquals(p1.getDescription(), pFound.getDescription());
		assertEquals(p1.getProgress(), pFound.getProgress());
		assertEquals(p1.getStatus(), pFound.getStatus());

		pFound = projectDao.findProjectByProjectIdAndUserId(u.getId(), p2.getId());
		assertNull("Expected project not to be found but was found", pFound);
	}

	@Test
	@Transactional
	public void testGetAllProjects() {
		Project p1 = DataProvider.getProject1Data();
		Project p2 = DataProvider.getProject2Data();

		Long idTmp = projectDao.saveProject(p1);
		p1 = projectDao.findProjectById(idTmp);

		List<Project> pListFound = projectDao.getAllProjects();
		List<String> pNames = new ArrayList<>();
		for (Project p : pListFound)
			pNames.add(p.getName());

		assertEquals(true, pNames.contains(p1.getName()));
		assertEquals(false, pNames.contains(p2.getName()));
	}

	@Test
	@Transactional
	public void testGetProjectsByUserId() {
		User u = DataProvider.getUser1Data();

		Long idTmp = userDao.saveUser(u);
		u = userDao.findUserById(idTmp);

		Project p1 = DataProvider.getProject1Data();
		Project p2 = DataProvider.getProject2Data();

		List<User> p1UsersList = new ArrayList<>();
		p1UsersList.add(u);
		p1.setUsers(p1UsersList);
		idTmp = projectDao.saveProject(p1);
		p1 = projectDao.findProjectById(idTmp);
		p2.setUsers(p1UsersList);
		idTmp = projectDao.saveProject(p2);
		p2 = projectDao.findProjectById(idTmp);

		List<Project> pListFound = projectDao.getProjectsByUserId(u.getId());
		assertEquals(2, pListFound.size());
		assertEquals(true, pListFound.get(0).getName().equals(p1.getName()) || pListFound.get(1).getName().equals(p1.getName()));
		assertEquals(true, pListFound.get(0).getName().equals(p2.getName()) || pListFound.get(1).getName().equals(p2.getName()));
	}

	@Test
	@Transactional
	public void testGetUsersByProjectId() {
		User u1 = DataProvider.getUser1Data();
		User u2 = DataProvider.getUser2Data();

		Long idTmp = userDao.saveUser(u1);
		u1 = userDao.findUserById(idTmp);
		idTmp = userDao.saveUser(u2);
		u2 = userDao.findUserById(idTmp);

		Project p1 = DataProvider.getProject1Data();

		List<User> p1UsersList = new ArrayList<>();
		p1UsersList.add(u1);
		p1UsersList.add(u2);
		p1.setUsers(p1UsersList);
		idTmp = projectDao.saveProject(p1);
		p1 = projectDao.findProjectById(idTmp);

		List<User> usersFound = projectDao.getUsersByProjectId(p1.getId());
		assertEquals(true, usersFound.contains(u1));
		assertEquals(true, usersFound.contains(u2));
	}
}
