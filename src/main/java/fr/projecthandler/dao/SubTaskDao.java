package fr.projecthandler.dao;

import java.util.List;
import java.util.Set;

import fr.projecthandler.model.SubTask;

public interface SubTaskDao {
	public Long saveSubtask(SubTask subTask);

	public void updateSubTask(SubTask subTask);

	public void deleteSubTaskById(Long subTaskId);
	
	public void deleteSubTasksByIds(List<Long> subTasksIds);

	public SubTask findSubTaskById(Long subTaskId);
	
	public Set<SubTask> getSubTasksByTaskId(Long taskId);

	public Set<SubTask> getSubTasksByUser(Long userId);

	public Set<SubTask> getSubTasksPlannedByUser(Long userId);

	public Set<SubTask> getSubTasksUnplannedByUser(Long userId);
}
