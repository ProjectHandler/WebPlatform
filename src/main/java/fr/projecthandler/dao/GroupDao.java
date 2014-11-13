package fr.projecthandler.dao;

import java.util.List;

import fr.projecthandler.model.Group;

public interface GroupDao {
	
	public Group findGroupById(Long groupId);

	public void updateGroup(Group group);

	public Long saveGroup(Group group);

	public List<Group> getAllGroups();
	
	public Group findGroupByName(String name);
	
	public void deleteGroupById(Long groupId);
}
