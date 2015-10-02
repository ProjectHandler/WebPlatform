package fr.projecthandler.service;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import fr.projecthandler.dao.SubTaskDao;
import fr.projecthandler.model.SubTask;

@Service
public class SubTaskServiceImpl implements SubTaskService {

	@Autowired
	SubTaskDao subTaskDao;
	
	@Override
	public Long saveSubtask(SubTask subTask) {
		return subTaskDao.saveSubtask(subTask);
	}

	@Override
	public void updateSubTask(SubTask subTask) {
		subTaskDao.updateSubTask(subTask);
	}

	@Override
	public void deleteSubTasksByIds(List<Long> subTasksIds) {
		subTaskDao.deleteSubTasksByIds(subTasksIds);
	}

	@Override
	public void deleteSubTaskById(Long id) {
		subTaskDao.deleteSubTaskById(id);
	}


	@Override
	public SubTask findSubTaskById(Long subTaskId) {
		return subTaskDao.findSubTaskById(subTaskId);
	}

	@Override
	public Set<SubTask> getSubTasksByTaskId(Long taskId) {
		return subTaskDao.getSubTasksByTaskId(taskId);
	}

	@Override
	public Set<SubTask> getSubTasksByUser(Long userId) {
		return subTaskDao.getSubTasksByUser(userId);
	}
	
	@Override
	public Set<SubTask> getSubTasksPlannedByUser(Long userId) {
		return subTaskDao.getSubTasksPlannedByUser(userId);
	}
	
	@Override
	public Set<SubTask> getSubTasksUnplannedByUser(Long userId) {
		return subTaskDao.getSubTasksUnplannedByUser(userId);
	}
}
