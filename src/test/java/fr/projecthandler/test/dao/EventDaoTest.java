package fr.projecthandler.test.dao;

import static org.junit.Assert.assertEquals;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.transaction.TransactionConfiguration;
import org.springframework.transaction.annotation.Transactional;

import fr.projecthandler.dao.EventDao;
import fr.projecthandler.dao.UserDao;
import fr.projecthandler.model.Event;
import fr.projecthandler.model.User;
import fr.projecthandler.test.content.DataProvider;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "/spring/test-config.xml"})
@TransactionConfiguration(defaultRollback = true)
public class EventDaoTest {
	@Autowired
	EventDao eventDao;
	
	@Autowired
	UserDao userDao;

	@Test
	@Transactional
	public void testFindEventById() {
		userDao.saveUser(DataProvider.getUser1Data());
		userDao.saveUser(DataProvider.getUser2Data());
		Event eventData = DataProvider.getEventData();
		Long eventId = eventDao.saveEvent(eventData);

		Event eventFound = eventDao.findEventById(eventId);
		assertEquals(eventFound.getId(), eventId);
		assertEquals(eventFound.getDescription(), eventData.getDescription());
		assertEquals(eventFound.getEndingDate(), eventData.getEndingDate());
		assertEquals(eventFound.getStartingDate(), eventData.getStartingDate());
		assertEquals(eventFound.getTitle(), eventData.getTitle());
		assertEquals(eventFound.getUsers(), eventData.getUsers());
		assertEquals(eventFound.getStatus(), eventData.getStatus());
		assertEquals(eventFound.getUsers(), eventData.getUsers());
	}

	@Test
	@Transactional
	public void testGetEventsByUser() {
		List<User> users = new ArrayList<>();
		Long userId = userDao.saveUser(DataProvider.getUser1Data());
		users.add(userDao.findUserById(userId));
		userId = userDao.saveUser(DataProvider.getUser2Data());
		users.add(userDao.findUserById(userId));
		Event eventData = DataProvider.getEventData();
		eventData.setUsers(users);
		eventDao.saveEvent(eventData);

		Set<Event> eventFound = eventDao.getEventsByUser(userId);
		assertEquals(1, eventFound.size());
		assertEquals(true, eventFound.contains(eventData));
	}

	@Test
	@Transactional
	public void testGetUserByEvent() {
		List<User> users = new ArrayList<>();
		Long user1Id = userDao.saveUser(DataProvider.getUser1Data());
		Long user2Id = userDao.saveUser(DataProvider.getUser2Data());
		users.add(userDao.findUserById(user1Id));
		users.add(userDao.findUserById(user2Id));
		Event eventData = DataProvider.getEventData();
		eventData.setUsers(users);
		Long eventId = eventDao.saveEvent(eventData);
		
		List<User> usersFound = new ArrayList<>();
		usersFound.addAll(eventDao.getUserByEvent(eventId));
		assertEquals(2, usersFound.size());
		assertEquals(true, usersFound.contains(users.get(0)));
		assertEquals(true, usersFound.contains(users.get(1)));
	}
}
