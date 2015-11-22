package fr.projecthandler.service;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import fr.projecthandler.dao.TaskDocumentDao;
import fr.projecthandler.model.TaskDocument;

@Service
public class TaskDocumentServiceImpl implements TaskDocumentService {

	@Autowired
	TaskDocumentDao taskDocumentDao;

	@Override
	public Long saveTaskDocument(TaskDocument taskDocument) {
		return taskDocumentDao.saveTaskDocument(taskDocument);
	}

	@Override
	public TaskDocument findTaskDocumentById(Long id) {
		return taskDocumentDao.findTaskDocumentById(id);
	}

	@Override
	public void updateTaskDocument(TaskDocument taskDocument) {
		taskDocumentDao.updateTaskDocument(taskDocument);
	}

	@Override
	public void deleteTaskDocumentsByIds(List<Long> taskDocumentsIdsList) {
		taskDocumentDao.deleteTaskDocumentsByIds(taskDocumentsIdsList);
	}

	@Override
	public Set<TaskDocument> getTaskDocumentsByTaskId(Long taskId) {
		return taskDocumentDao.getTaskDocumentsByTask(taskId);
	}
}
