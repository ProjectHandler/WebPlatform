package fr.projecthandler.dao;

import java.util.List;
import java.util.Set;

import fr.projecthandler.model.Task;
import fr.projecthandler.model.User;

public interface TaskDao {

	public Long saveTask(Task task);

	public void updateTask(Task task);

	public void deleteTasksByIds(List<Long> tasksIds);

	public Task findTaskById(Long taskId);

	public Set<Task> getTasksByProjectId(Long projectId);
	
	public Set<Task> getTasksByTaskIdWithDepends(Long taskId);
	
	public Set<Task> getTasksByUserAndFetchUsers(Long userId);
	
	public List<User> getUsersByTaskId(Long taskId);
	
	public Set<Task> getYesterdayTasksByUser(Long userId);
	
	public Set<Task> getTodayTasksByUser(Long userId);
	
	public Set<Task> getTomorrowTasksByUser(Long userId);
	
	public Set<Task> getTasksByProjectIdWithDepends(Long projectId);
	
	public Set<Task> getTasksByProjectIdAndUserIdWithDepends(Long projectId, Long userId);
}