package fr.projecthandler.dao;

import java.util.List;
import java.util.Set;

import fr.projecthandler.model.Task;

public interface TaskDao {

	public Task findTaskById(Long taskId);

	public void updateTask(Task task);

	public Long saveTask(Task task);

	public void deleteTaskByListIds(List<Long> tasksIds);
	
	public Set<Task> findAllTasksByProjectId(Long projectId);
}