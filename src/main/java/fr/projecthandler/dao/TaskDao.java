package fr.projecthandler.dao;

import java.util.List;
import java.util.Set;

import fr.projecthandler.model.Task;

public interface TaskDao {

	public Long saveTask(Task task);

	public void updateTask(Task task);

	public void deleteTasksByIds(List<Long> tasksIds);

	public Task findTaskById(Long taskId);

	public Set<Task> getTasksByProjectId(Long projectId);
	
	public Set<Task> getTasksByProjectIdWithDepends(Long projectId);
}