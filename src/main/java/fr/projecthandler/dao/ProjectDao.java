package fr.projecthandler.dao;

import java.util.List;

import fr.projecthandler.model.Project;


public interface ProjectDao {

	public Project findProjectById(Long projectId);

	public void updateProject(Project project);

	public Long saveProject(Project project);

	public void deleteProjectByListIds(List<Long> projectIds);
}