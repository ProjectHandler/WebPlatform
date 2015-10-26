package fr.projecthandler.service;

import java.util.List;
import java.util.Set;

import fr.projecthandler.model.SubTask;

public interface SubTaskService {

	public Long saveSubtask(SubTask subTask);

	public void updateSubTask(SubTask subTask);

	public void deleteSubTasksByIds(List<Long> subTasksIds);

	public void deleteSubTaskById(Long id);

	public SubTask findSubTaskById(Long subTaskId);

	public Set<SubTask> getSubTasksByTaskIdAndFetchUserAndTask(Long taskId);

	public Set<SubTask> getSubTasksByUser(Long userId);

	public Set<SubTask> getSubTasksPlannedByUser(Long userId);

	public Set<SubTask> getSubTasksUnplannedByUser(Long userId);
}
