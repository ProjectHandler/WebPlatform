package fr.projecthandler.service;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import fr.projecthandler.dao.TaskDao;
import fr.projecthandler.dao.TaskPriorityDao;
import fr.projecthandler.model.Task;
import fr.projecthandler.model.TaskPriority;
import fr.projecthandler.model.User;

@Service
public class TaskServiceImpl implements TaskService {

	@Autowired
	TaskDao taskDao;

	@Autowired
	TaskPriorityDao taskPriorityDao;

	public Long saveTask(Task newTask) {
		return taskDao.saveTask(newTask);
	}

	public Task findTaskById(Long id) {
		return taskDao.findTaskById(id);
	}

	public void updateTask(Task t) {
		taskDao.updateTask(t);
	}

	public void deleteTasksByIds(List<Long> tasksIdsList) {
		taskDao.deleteTasksByIds(tasksIdsList);
	}

	public Set<Task> getTasksByProjectId(Long projectId) {
		return taskDao.getTasksByProjectId(projectId);
	}

	public Set<Task> getTasksByTaskIdWithDepends(Long taskId) {
		return taskDao.getTasksByTaskIdWithDepends(taskId);
	}

	public Set<Task> getTasksByUserAndFetchUsers(Long userId) {
		return taskDao.getTasksByUserAndFetchUsers(userId);
	}

	public List<User> getUsersByTaskId(Long taskId) {
		return taskDao.getUsersByTaskId(taskId);
	}

	public Set<Task> getYesterdayTasksByUser(Long userId) {
		return taskDao.getYesterdayTasksByUser(userId);
	}

	public Set<Task> getTodayTasksByUser(Long userId) {
		return taskDao.getTodayTasksByUser(userId);
	}

	public Set<Task> getTomorrowTasksByUser(Long userId) {
		return taskDao.getTomorrowTasksByUser(userId);
	}

	public Long saveTaskPriority(TaskPriority taskPriority) {
		return taskPriorityDao.saveTaskPriority(taskPriority);
	}

	public void updateTaskPriority(TaskPriority taskPriority) {
		taskPriorityDao.updateTaskPriority(taskPriority);
	}

	public void deleteTaskPriorityById(Long taskPriorityId) {
		taskPriorityDao.deleteTaskPriorityById(taskPriorityId);
	}

	public void deleteTaskPrioritiesByIds(List<Long> taskPriorities) {
		taskPriorityDao.deleteTaskPrioritiesByIds(taskPriorities);
	}

	public TaskPriority findTaskPriorityById(Long taskPriorityId) {
		return taskPriorityDao.findTaskPriorityById(taskPriorityId);
	}

	public List<TaskPriority> getAllTaskPriorities() {
		return taskPriorityDao.getAllTaskPriorities();
	}

	public Set<Task> getTasksByProjectIdWithDepends(Long projectId) {
		return taskDao.getTasksByProjectIdWithDepends(projectId);
	}

	public Set<Task> getTasksByProjectIdAndUserIdWithDepends(Long projectId, Long userId) {
		return taskDao.getTasksByProjectIdAndUserIdWithDepends(projectId, userId);
	}

	public Set<Task> getTasksByUser(Long userId) {
		return taskDao.getTasksByUser(userId);
	}
	
	public Long findMaxTaskRowByProjectId(Long projectId) {
		return taskDao.findMaxTaskRowByProjectId(projectId);
	}
}
