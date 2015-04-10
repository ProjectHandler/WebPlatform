package fr.projecthandler.service;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import fr.projecthandler.dao.TaskDao;
import fr.projecthandler.model.Task;

@Service
public class TaskServiceImpl implements TaskService {

	@Autowired
	TaskDao taskDao;

	public Long saveTask(Task newTask) {
		return taskDao.saveTask(newTask);
	}

	public Task findTaskById(Long id) {
		return taskDao.findTaskById(id);
	}

	public void updateTask(Task t) {
		taskDao.updateTask(t);
	}

	public void deleteTasksByIds(List<Long> TasksIdsList) {
		taskDao.deleteTasksByIds(TasksIdsList);
	}

	public Set<Task> getTasksByProjectId(Long projectId) {
		return taskDao.getTasksByProjectId(projectId);
	}

	public Set<Task> getTasksByProjectIdWithDepends(Long projectId){
		return taskDao.getTasksByProjectIdWithDepends(projectId);
	}
	
	public Set<Task> getTasksByUserAndFetchUsers(Long userId){
		return taskDao.getTasksByUserAndFetchUsers(userId);
	}
}
