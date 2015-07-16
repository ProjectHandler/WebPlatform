package fr.projecthandler.service;

import java.util.List;
import java.util.Set;

import fr.projecthandler.model.Task;
import fr.projecthandler.model.User;

public interface TaskService {

	public Long saveTask(Task newTask);

	public Task findTaskById(Long id);

	public void updateTask(Task t);

	public void deleteTasksByIds(List<Long> TasksIdsList);

	public Set<Task> getTasksByProjectId(Long projectId);
	
	public Set<Task> getTasksByProjectIdWithDepends(Long projectId);
	
	public Set<Task> getTasksByUserAndFetchUsers(Long userId);
	
	public List<User> getUsersByTaskId(Long taskId);
	
	public Set<Task> getYesterdayTasksByUser(Long userId);
	
	public Set<Task> getTodayTasksByUser(Long userId);
	
	public Set<Task> getTomorrowTasksByUser(Long userId);
}
