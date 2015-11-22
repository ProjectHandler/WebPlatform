package fr.projecthandler.dao;

import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import fr.projecthandler.model.TaskDocument;
import fr.projecthandler.util.Utilities;

@Component
public class TaskDocumentDaoImpl extends AbstractDao implements TaskDocumentDao {

	@Override
	@Transactional
	public Long saveTaskDocument(TaskDocument taskDocument) {
		em.persist(taskDocument);
		return taskDocument.getId();
	}

	@Override
	@Transactional
	public TaskDocument findTaskDocumentById(Long taskDocumentId) {
		return (TaskDocument) Utilities.getSingleResultOrNull(em.createQuery("SELECT td FROM TaskDocument td WHERE td.id = :taskDocumentId")
				.setParameter("taskDocumentId", taskDocumentId));
	}

	@Override
	@Transactional
	public void updateTaskDocument(TaskDocument taskDocument) {
		em.merge(taskDocument);
	}

	@Override
	@Transactional
	public void deleteTaskDocumentsByIds(List<Long> taskDocumentsIdsList) {
		em.createQuery("DELETE FROM TaskDocument td WHERE td.id IN (:taskDocumentsIdsList)").setParameter("taskDocumentsIdsList", taskDocumentsIdsList).executeUpdate();
	}

	@Override
	public Set<TaskDocument> getTaskDocumentsByTask(Long taskId) {
		LinkedHashSet<TaskDocument> result = new LinkedHashSet<TaskDocument>();
		result.addAll(em.createQuery("SELECT tds FROM TaskDocument tds WHERE tds.taskId = :taskId")
				.setParameter("taskId", taskId).getResultList());
		return result;
	}
}
