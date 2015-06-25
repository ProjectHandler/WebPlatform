package fr.projecthandler.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import fr.projecthandler.dao.AddressDao;
import fr.projecthandler.dao.GroupDao;
import fr.projecthandler.dao.UserDao;
import fr.projecthandler.enums.UserRole;
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
	public List<User> getAllActiveUsers() {
		return userDao.getAllActiveUsers();
	}
	
	@Override
	public List<User> getUsersByRole(UserRole userRole) {
		return userDao.getUsersByRole(userRole);
	}
	
	@Override
	public List<Group> getAllGroups() {
		return groupDao.getAllGroups();
	}
	
	@Override
	public List<Group> getAllNonEmptyGroups() {
		List<Group> nonEmptyGroups = new ArrayList<Group>();
		List<Group> groups = groupDao.getAllGroups();
		
		for(Group g : groups)
			if (!g.getUsers().isEmpty())
				nonEmptyGroups.add(g);
		return nonEmptyGroups;
	}
	
	@Override
	public Group findGroupById(Long groupId) {
		return groupDao.findGroupById(groupId);
	}
	
	@Override
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
			e.printStackTrace();
			return "The group called " + groupName + " already exists.";
		}
	}
	
	@Override
	public void deleteGroupById(Long groupId) {
		groupDao.deleteGroupById(groupId);
	}
	
	@Override
	public void changeGroup(Long userId, Long groupId, String action) {
		User user = findUserById(userId);
		Group group = findGroupById(groupId);
		if (action.equals("add"))
			user.addGroup(group);
		else
			user.removeGroup(group);
		updateUser(user);
	}

	@Override
	public User findUserByIdAndFetchProjects(Long userId) {
		return userDao.findUserByIdAndFetchProjects(userId);
	}

	
	@Override
	public List<User> getGroupUsersByGroupId(Long groupId) {
		return groupDao.getGroupUsersByGroupId(groupId);
	}
}