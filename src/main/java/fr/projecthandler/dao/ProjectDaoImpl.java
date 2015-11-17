package fr.projecthandler.dao;

import java.util.List;

import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import fr.projecthandler.model.Project;
import fr.projecthandler.model.User;
import fr.projecthandler.util.Utilities;

@Component
public class ProjectDaoImpl extends AbstractDao implements ProjectDao {

	@Override
	@Transactional
	public void updateProject(Project project) {
		em.merge(project);
	}

	@Override
	@Transactional
	public Long saveProject(Project project) {
		em.persist(project);
		return project.getId();
	}

	@Override
	@Transactional
	public void deleteProjectsByIds(List<Long> projectIds) {
		em.createQuery("DELETE FROM Project p WHERE p.id IN (:projectIds)").setParameter("projectIds", projectIds).executeUpdate();
	}

	@Override
	public Project findProjectById(Long projectId) {
		return (Project) Utilities.getSingleResultOrNull(em.createQuery("SELECT p FROM Project p WHERE p.id = :projectId").setParameter("projectId",
				projectId));
	}

	@Override
	public List<Project> getAllProjects() {
		return (List<Project>) em.createQuery("FROM Project p").getResultList();
	}

	@Override
	public List<Project> getProjectsByUserId(Long userId) {
		return (List<Project>) em.createQuery("SELECT projects FROM User u WHERE u.id = :userId").setParameter("userId", userId).getResultList();
	}

	public List<Project> getProjectsByUserIdAndFetchUsers(Long userId) {
		return (List<Project>) em.createQuery("SELECT p FROM Project p LEFT JOIN FETCH p.users us WHERE us.id = :userId")
				.setParameter("userId", userId).getResultList();
	}

	@Override
	public List<Project> getProjectsByUserIdAndFetchTasks(Long userId) {
		return (List<Project>) em.createQuery("SELECT DISTINCT P FROM Project p JOIN p.users u JOIN p.tasks t WHERE u.id = :userId")
				.setParameter("userId", userId).getResultList();
	}

	@Override
	@Transactional
	public void deleteProjectById(Long id) {
		em.createQuery("DELETE FROM Project p WHERE p.id =:id").setParameter("id", id).executeUpdate();
	}

	@Override
	public List<User> getUsersByProjectId(Long projectId) {
		return (List<User>) em.createQuery("SELECT p.users FROM Project p WHERE p.id = :projectId").setParameter("projectId", projectId)
				.getResultList();
	}
}
