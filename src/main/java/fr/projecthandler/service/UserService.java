package fr.projecthandler.service;

import java.io.File;
import java.util.List;

import fr.projecthandler.enums.UserRole;
import fr.projecthandler.model.Group;
import fr.projecthandler.model.User;

public interface UserService {

	public Long saveUser(User user);

	public void updateUser(User user);

	public User getUserByEmail(String email);

	public User findUserById(Long userId);

	public void deleteUserByIds(List<Long> usersList);

	public List<User> getAllUsers();

	public List<User> getAllActiveUsers();

	public List<User> getUsersByRole(UserRole userRole);

	public List<Group> getAllGroups();

	public List<Group> getAllNonEmptyGroups();

	public Group findGroupById(Long groupId);

	public String createGroup(String groupName);

	public void deleteGroupById(Long groupId);

	public void changeGroup(Long userId, Long groupId, String action);

	public User findUserByIdAndFetchProjects(Long userId);

	public List<User> getGroupUsersByGroupId(Long groupId);

	public File getUserAvatarFile(Long userId);

}