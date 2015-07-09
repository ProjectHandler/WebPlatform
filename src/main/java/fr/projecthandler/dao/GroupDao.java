package fr.projecthandler.dao;

import java.util.List;

import fr.projecthandler.model.Group;
import fr.projecthandler.model.User;

public interface GroupDao {

	public Long saveGroup(Group group);

	public void deleteGroupById(Long groupId);

	public void updateGroup(Group group);

	public Group findGroupById(Long groupId);

	public List<Group> getAllGroups();
	
	public List<Group> getAllNonEmptyGroups();

	public Group findGroupByName(String name);
	
	public List<User> getGroupUsersByGroupId(Long groupId);
}
