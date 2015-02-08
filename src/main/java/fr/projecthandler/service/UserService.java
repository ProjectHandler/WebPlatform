package fr.projecthandler.service;

import java.util.List;

import fr.projecthandler.model.Group;
import fr.projecthandler.model.Project;
import fr.projecthandler.model.User;

public interface UserService {

	public Long saveUser(User user);

	public void updateUser(User user);
	
	public User getUserByEmail(String email);

	public User findUserById(Long userId);

	public void deleteUserByIds(List<Long> usersList);

	public List<User> getAllUsers();
	
	public List<Group> getAllGroups();
	
	public Group findGroupById(Long groupId);
	
	public String createGroup(String groupName);
	
	public void deleteGroupById(Long groupId);
	
	public void changeGroup(Long userId, Long groupId, String action);
	
	public Project loadGantt(Long projectId);
}