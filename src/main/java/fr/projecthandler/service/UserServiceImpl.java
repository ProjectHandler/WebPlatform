package fr.projecthandler.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import fr.projecthandler.dao.AddressDao;
import fr.projecthandler.dao.GroupDao;
import fr.projecthandler.dao.UserDao;
import fr.projecthandler.model.Group;
import fr.projecthandler.model.User;

@Service
public class UserServiceImpl implements UserService {

	@Autowired
	UserDao userDao;

	@Autowired
	AddressDao addressDao;

	@Autowired
	GroupDao groupDao;
	
	@Override
	public Long saveUser(User user) {
		return userDao.saveUser(user);
	}
	
	@Override
	public User getUserByEmail(String email) {
		return userDao.findByEmail(email);
	}

	@Override
	public void updateUser(User user) {
		userDao.updateUser(user);
	}

	@Override
	public void deleteUserByIds(List<Long> usersList) {
		userDao.deleteUserByListIds(usersList);
	}
	
	@Override
	public User findUserById(Long userId) {
		return userDao.findUserById(userId);
	}

	@Override
	public List<User> getAllUsers() {
		return userDao.getAllUsers();
	}
	
	@Override
	public List<Group> getAllGroups() {
		return groupDao.getAllGroups();
	}
	
	public String createGroup(String groupName) {
		try {
			if (groupDao.findGroupByName(groupName) == null) {
				System.out.println("1");
				Group group = new Group();
				group.setName(groupName);
				groupDao.saveGroup(group);
				return "OK";
			} else {
				System.out.println("2");
				return "The group called " + groupName + " already exists.";
			}
		} catch (Exception e) {
			System.out.println(e);
			return "The group called " + groupName + " already exists.";
		}
	}
	
	public void deleteGroupById(Long groupId) {
		groupDao.deleteGroupById(groupId);
	}
}