package fr.projecthandler.dao;

import java.util.List;

import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import fr.projecthandler.model.Group;
import fr.projecthandler.util.Utilities;

@Component
public class GroupDaoImpl extends AbstractDao implements GroupDao {

	@Override
	@Transactional
	public Long saveGroup(Group group) {
		em.persist(group);
		return group.getId();
	}

	@Override
	@Transactional
	public void updateGroup(Group group) {
		em.merge(group);
	}

	@Override
	@Transactional
	public void deleteGroupById(Long groupId) {
		em.createQuery("DELETE FROM Group g WHERE g.id = :groupId").setParameter("groupId", groupId).executeUpdate();
	}

	@Override
	public Group findGroupById(Long groupId) {
		return (Group) Utilities.getSingleResultOrNull(em.createQuery("SELECT g FROM Group g WHERE g.id = :groupId")
				.setParameter("groupId", groupId));
	}

	@Override
	public List<Group> getAllGroups() {
		return (List<Group>)em.createQuery("SELECT g FROM Group g").getResultList();
	}

	@Override
	public Group findGroupByName(String name) {
		return (Group) Utilities.getSingleResultOrNull(em.createQuery("SELECT g FROM Group g WHERE g.name = :groupName")
				.setParameter("groupName", name));
	}
}
