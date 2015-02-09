package fr.projecthandler.dao;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import fr.projecthandler.model.Task;
import fr.projecthandler.util.Utilities;

@Component
public class TaskDaoImpl  extends AbstractDao implements TaskDao {

	@Override
	public  Task findTaskById(Long taskId) {
		return (Task) Utilities.getSingleResultOrNull(em.createQuery("Select t from Task t where t.id = :taskId")
				.setParameter("taskId", taskId));
	}

	@Override
	@Transactional
	public void updateTask(Task task) {
		em.merge(task);
	}

	@Override
	@Transactional
	public Long saveTask(Task task) {
		em.persist(task);
		return task.getId();
	}

	@Override
	@Transactional
	public void deleteTaskByListIds(List<Long> tasksIds) {
		em.createQuery("DELETE FROM Task t WHERE t.id IN (:tasksIds)")
		.setParameter("tasksIds", tasksIds).executeUpdate();
	}
	
	@Override
	public Set<Task> findAllTasksByProjectId(Long projectId) {
		Set<Task> result = new HashSet<Task>();
		result.addAll( em.createQuery("SELECT t FROM Task t WHERE t.project.id = :projectId")
				.setParameter("projectId", projectId).getResultList());
		return result;
	}
}