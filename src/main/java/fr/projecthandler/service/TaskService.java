package fr.projecthandler.service;

import java.util.List;
import java.util.Set;

import fr.projecthandler.model.Task;

public interface TaskService {

	public Long saveTask(Task newTask);

	public Task findTaskById(Long id);

	public void updateTask(Task t);

	public void deleteTasksByIds(List<Long> TasksIdsList);

	public Set<Task> getTasksByProjectId(Long projectId);
}
