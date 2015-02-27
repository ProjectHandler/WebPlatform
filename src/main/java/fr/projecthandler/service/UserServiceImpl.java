package fr.projecthandler.service;

import java.util.Date;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import fr.projecthandler.dao.AddressDao;
import fr.projecthandler.dao.GroupDao;
import fr.projecthandler.dao.ProjectDao;
import fr.projecthandler.dao.TaskDao;
import fr.projecthandler.dao.UserDao;
import fr.projecthandler.model.Group;
import fr.projecthandler.model.Project;
import fr.projecthandler.model.Task;
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
		userDao.deleteUsersByIds(usersList);
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
	
	@Override
	public Group findGroupById(Long groupId) {
		return groupDao.findGroupById(groupId);
	}
	
	public String createGroup(String groupName) {
		try {
			if (groupDao.findGroupByName(groupName) == null) {
				Group group = new Group();
				group.setName(groupName);
				groupDao.saveGroup(group);
				return "OK";
			} else {
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
	
	public void changeGroup(Long userId, Long groupId, String action) {
		User user = findUserById(userId);
		Group group = findGroupById(groupId);
		if (action.equals("add"))
			user.addGroup(group);
		else
			user.removeGroup(group);
		updateUser(user);
	}
}