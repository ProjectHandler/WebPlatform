package fr.projecthandler.dao;

import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import fr.projecthandler.model.TaskMessage;
import fr.projecthandler.util.Utilities;

@Component
public class TaskMessageDaoImpl extends AbstractDao implements TaskMessageDao {

	@Override
	@Transactional
	public Long saveTaskMessage(TaskMessage taskMessage) {
		em.persist(taskMessage);
		return taskMessage.getId();
	}

	@Override
	@Transactional
	public void updateTaskMessage(TaskMessage taskMessage) {
		em.merge(taskMessage);
	}

	@Override
	@Transactional
	public void deleteTaskMessageById(Long taskMessageId) {
		em.createQuery("DELETE FROM TaskMessage tm WHERE tm.id = :taskMessageId").setParameter("taskMessageId", taskMessageId).executeUpdate();
	}

	@Override
	@Transactional
	public void deleteTaskMessagesByIds(List<Long> taskMessageIds) {
		em.createQuery("DELETE FROM TaskMessage tm WHERE tm.id IN (:taskMessageIds)").setParameter("taskMessageIds", taskMessageIds).executeUpdate();
	}

	@Override
	public TaskMessage findTaskMessageById(Long taskMessageId) {
		return (TaskMessage) Utilities.getSingleResultOrNull(em.createQuery("SELECT tm FROM TaskMessage tm WHERE tm.id = :taskMessageId")
				.setParameter("taskMessageId", taskMessageId));
	}

	@Override
	public Set<TaskMessage> getTaskMessagesByTaskId(Long taskId) {
		LinkedHashSet<TaskMessage> result = new LinkedHashSet<TaskMessage>();
		result.addAll(em.createQuery("SELECT tms FROM TaskMessage tms WHERE tms.task.id = :taskId ORDER BY tms.updateDate DESC")
				.setParameter("taskId", taskId).getResultList());
		return result;
	}

}
