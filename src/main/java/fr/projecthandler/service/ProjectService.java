package fr.projecthandler.service;

import java.util.List;

import fr.projecthandler.model.Project;

public interface ProjectService {

	public Long saveProject(Project project);

	public void updateProject(Project project);

	public void deleteProjectsByIds(List<Long> projectIds);
	
	public Project findProjectById(Long projectId);

	public List<Project> getAllProjects();
	
	public List<Project> getProjectsByUserId(Long userId);
	
	public void deleteProjectById(Long projectId);
	
	public Project loadGantt(Long projectId);
}
