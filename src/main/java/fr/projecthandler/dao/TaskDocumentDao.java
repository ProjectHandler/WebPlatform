package fr.projecthandler.dao;

import java.util.List;
import java.util.Set;

import fr.projecthandler.model.TaskDocument;

public interface TaskDocumentDao {
	public Long saveTaskDocument(TaskDocument taskDocument);

	public TaskDocument findTaskDocumentById(Long id);

	public void updateTaskDocument(TaskDocument taskDocument);

	public void deleteTaskDocumentsByIds(List<Long> taskDocumentsIdsList);

	public Set<TaskDocument> getTaskDocumentsByTask(Long taskId);
}
