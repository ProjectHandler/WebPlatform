package fr.projecthandler.dao;

import java.util.List;

import fr.projecthandler.model.TaskPriority;

public interface TaskPriorityDao {
	public Long saveTaskPriority(TaskPriority TaskPriority);

	public void updateTaskPriority(TaskPriority TaskPriority);

	public void deleteTaskPriorityById(Long TaskPriorityId);

	public void deleteTaskPrioritiesByIds(List<Long> TaskPriorities);

	public TaskPriority findTaskPriorityById(Long TaskPriorityId);

	public List<TaskPriority> getAllTaskPriorities();
}
