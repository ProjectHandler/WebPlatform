package fr.projecthandler.dao;

import java.util.List;

import fr.projecthandler.model.Project;


public interface ProjectDao {

	public Long saveProject(Project project);

	public void updateProject(Project project);

	public void deleteProjectByListIds(List<Long> projectIds);
	
	public Project findProjectById(Long projectId);

	public List<Project> getAllProjects();
	
	public List<Project> getProjectsByUserId(Long userId);
}