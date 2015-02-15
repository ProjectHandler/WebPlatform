package fr.projecthandler.dao;

import java.util.List;

import fr.projecthandler.model.Group;

public interface GroupDao {

	public Long saveGroup(Group group);

	public void deleteGroupById(Long groupId);

	public void updateGroup(Group group);

	public Group findGroupById(Long groupId);

	public List<Group> getAllGroups();
	
	public Group findGroupByName(String name);
	
}
