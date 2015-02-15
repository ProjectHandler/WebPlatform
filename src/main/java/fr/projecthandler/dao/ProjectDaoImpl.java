package fr.projecthandler.dao;

import java.util.List;

import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import fr.projecthandler.model.Project;
import fr.projecthandler.util.Utilities;

@Component
public class ProjectDaoImpl  extends AbstractDao implements ProjectDao {

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
	public void deleteProjectByListIds(List<Long> projectIds) {
		em.createQuery("DELETE FROM Project p WHERE p.id IN (:projectIds)")
		.setParameter("projectIds", projectIds).executeUpdate();
	}

	@Override
	public  Project findProjectById(Long projectId) {
		return (Project) Utilities.getSingleResultOrNull(em.createQuery("SELECT p FROM Project p WHERE p.id = :projectId")
				.setParameter("projectId", projectId));
	}

	@Override
	public List<Project> getAllProjects() {
		return (List<Project>)em.createQuery("FROM Project p").getResultList();
	}
}
