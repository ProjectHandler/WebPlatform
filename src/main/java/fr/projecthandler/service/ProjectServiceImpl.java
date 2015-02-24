package fr.projecthandler.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import fr.projecthandler.dao.ProjectDao;
import fr.projecthandler.dao.TokenDao;
import fr.projecthandler.model.Project;
import fr.projecthandler.model.Token;
import fr.projecthandler.model.User;

@Service
public class ProjectServiceImpl implements ProjectService {

	@Autowired
	ProjectDao projectDao;

	@Override
	public Long saveProject(Project newProject) {
		return projectDao.saveProject(newProject);
	}

	@Override
	public void updateProject(Project a) {
		projectDao.updateProject(a);
	}

	@Override
	public Project findProjectById(Long id) {
		return projectDao.findProjectById(id);
	}

	@Override
	public void deleteProjectsByIds(List<Long> projectIds) {
		projectDao.deleteProjectsByIds(projectIds);;
	}

	@Override
	public List<Project> getAllProjects() {
		return projectDao.getAllProjects();
	}

	@Override
	public List<Project> getProjectsByUserId(Long userId) {
		return projectDao.getProjectsByUserId(userId);
	}

	@Override
	public void deleteProjectById(Long projectId) {
		projectDao.deleteProjectById(projectId);
	}

	@Override
	public Project loadGantt(Long projectId) {
		return projectDao.findProjectById(projectId);
	}
}
