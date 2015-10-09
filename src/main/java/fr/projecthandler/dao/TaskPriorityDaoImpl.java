package fr.projecthandler.dao;

import java.util.List;

import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import fr.projecthandler.model.TaskPriority;
import fr.projecthandler.util.Utilities;

@Component
public class TaskPriorityDaoImpl extends AbstractDao implements TaskPriorityDao {

	@Override
	@Transactional
	public void updateTaskPriority(TaskPriority taskPriority) {
		em.merge(taskPriority);
	}

	@Override
	@Transactional
	public Long saveTaskPriority(TaskPriority taskPriority) {
		em.persist(taskPriority);

		return taskPriority.getId();
	}

	@Override
	@Transactional
	public void deleteTaskPrioritiesByIds(List<Long> taskPrioritiesIdsList) {
		em.createQuery("DELETE FROM TaskPriority tt WHERE tt.id IN (:taskPrioritiesIdsList)")
				.setParameter("taskPrioritiesIdsList", taskPrioritiesIdsList).executeUpdate();
	}

	@Override
	@Transactional
	public void deleteTaskPriorityById(Long taskPriorityId) {
		em.createQuery("DELETE FROM TaskPriority tt WHERE tt.id = :taskPriorityId").setParameter("taskPriorityId", taskPriorityId).executeUpdate();
	}

	@Override
	public TaskPriority findTaskPriorityById(Long taskPriorityId) {
		return (TaskPriority) Utilities.getSingleResultOrNull(em.createQuery("SELECT tt FROM TaskPriority tt WHERE tt.id = :taskPriorityId")
				.setParameter("taskPriorityId", taskPriorityId));
	}

	@Override
	public List<TaskPriority> getAllTaskPriorities() {
		return (List<TaskPriority>) em.createQuery("SELECT tt FROM TaskPriority tt").getResultList();
	}

}
