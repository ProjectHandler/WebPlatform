package fr.projecthandler.service;

import java.util.List;
import java.util.Set;

import fr.projecthandler.model.TaskDocument;

public interface TaskDocumentService {
	public Long saveTaskDocument(TaskDocument taskDocument);

	public TaskDocument findTaskDocumentById(Long id);

	public void updateTaskDocument(TaskDocument taskDocument);

	public void deleteTaskDocumentsByIds(List<Long> documentIdsList);

	public Set<TaskDocument> getTaskDocumentsByTaskId(Long taskId);
}
