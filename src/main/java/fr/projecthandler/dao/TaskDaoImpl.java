package fr.projecthandler.dao;

import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import fr.projecthandler.model.Task;
import fr.projecthandler.model.User;
import fr.projecthandler.util.DateHelper;
import fr.projecthandler.util.Utilities;

@Component
public class TaskDaoImpl extends AbstractDao implements TaskDao {

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
	public void deleteTasksByIds(List<Long> tasksIds) {
		em.createQuery("DELETE FROM Task t WHERE t.id IN (:tasksIds)")
				.setParameter("tasksIds", tasksIds).executeUpdate();
	}

	@Override
	public Task findTaskById(Long taskId) {
		return (Task) Utilities.getSingleResultOrNull(em.createQuery(
				"SELECT t FROM Task t WHERE t.id = :taskId").setParameter(
				"taskId", taskId));
	}

	@Override
	public Set<Task> getTasksByProjectId(Long projectId) {
		LinkedHashSet<Task> result = new LinkedHashSet<Task>();
		result.addAll(em
				.createQuery(
						"SELECT t FROM Task t WHERE t.project.id = :projectId ORDER BY t.row ASC")
				.setParameter("projectId", projectId).getResultList());
		return result;
	}

	@Override
	public Set<Task> getTasksByTaskIdWithDepends(Long taskId) {
		LinkedHashSet<Task> result = new LinkedHashSet<Task>();
		result.addAll(em
				.createQuery(
						"SELECT t FROM Task t, Task t2 WHERE t MEMBER OF t2.dependtasks AND t2.id = :taskId ORDER BY t.row ASC")
				.setParameter("taskId", taskId).getResultList());
		return result;
	}

	@Override
	public Set<Task> getTasksByUserAndFetchUsers(Long userId) {
		Set<Task> result = new HashSet<Task>();
		result.addAll(em
				.createQuery(
						"SELECT t FROM Task t JOIN FETCH t.users u WHERE :userId IN (u.id)")
				.setParameter("userId", userId).getResultList());
		return result;
	}

	@Override
	public List<User> getUsersByTaskId(Long taskId) {
		return (List<User>) em
				.createQuery("SELECT t.users FROM Task t WHERE t.id = :taskId")
				.setParameter("taskId", taskId).getResultList();
	}

	// Every functions below retrieve task level 2 only (sub-task)
	@Override
	public Set<Task> getYesterdayTasksByUser(Long userId) {
		Set<Task> result = new HashSet<Task>();
		result.addAll(em
				.createQuery(
						"SELECT t FROM Task t JOIN t.users AS u WHERE t.level = 2 AND t.startingDate = '"
								+ DateHelper.getYesterdayDate("yyyy-MM-dd")
								+ "' AND :userId IN (u.id)")
				.setParameter("userId", userId).getResultList());
		return result;
	}

	@Override
	public Set<Task> getTodayTasksByUser(Long userId) {
		Set<Task> result = new HashSet<Task>();
		result.addAll(em
				.createQuery(
						"SELECT t FROM Task t JOIN t.users AS u WHERE t.level = 2 AND t.startingDate = '"
								+ DateHelper.getTodayDate("yyyy-MM-dd")
								+ "' AND :userId IN (u.id)")
				.setParameter("userId", userId).getResultList());
		return result;
	}

	@Override
	public Set<Task> getTomorrowTasksByUser(Long userId) {
		Set<Task> result = new HashSet<Task>();
		result.addAll(em
				.createQuery(
						"SELECT t FROM Task t JOIN t.users AS u WHERE t.level = 2 AND t.startingDate = '"
								+ DateHelper.getTomorrowDate("yyyy-MM-dd")
								+ "' AND :userId IN (u.id)")
				.setParameter("userId", userId).getResultList());
		return result;
	}
	
	public Set<Task> getTasksByProjectIdWithDepends(Long projectId) {
		LinkedHashSet<Task> result = new LinkedHashSet<Task>();
		result.addAll(em
				.createQuery(
						"SELECT t FROM Task t LEFT JOIN FETCH t.dependtasks WHERE t.project.id = :projectId ORDER BY t.row ASC")
				.setParameter("projectId", projectId).getResultList());
		return result;
	}
	
	public Set<Task> getTasksByProjectIdAndUserIdWithDepends(Long projectId, Long userId) {
		LinkedHashSet<Task> result = new LinkedHashSet<Task>();
		System.out.println("tashesh");
		result.addAll(em
				.createQuery(
						"SELECT t FROM Task t LEFT JOIN FETCH t.dependtasks JOIN t.users u WHERE t.project.id = :projectId AND u.id = :userId ORDER BY t.row ASC")
				.setParameter("projectId", projectId)
				.setParameter("userId", userId)
				.getResultList());
		return result;
	}
}
