package fr.projecthandler.dao;

import java.util.LinkedHashSet;
import java.util.List;
import java.util.Set;

import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import fr.projecthandler.model.SubTask;
import fr.projecthandler.util.Utilities;

@Component
public class SubTaskDaoImpl  extends AbstractDao implements SubTaskDao {

	@Override
	@Transactional
	public Long saveSubtask(SubTask subTask) {
		em.persist(subTask);
		return subTask.getId();
	}

	@Override
	@Transactional
	public void updateSubTask(SubTask subTask) {
		em.merge(subTask);
	}

	@Override
	@Transactional
	public void deleteSubTaskById(Long id) {
		em.createQuery("DELETE FROM SubTask st WHERE st.id =:id").setParameter("id", id).executeUpdate();
	}
	
	@Override
	@Transactional
	public void deleteSubTasksByIds(List<Long> subTasksIds) {
		em.createQuery("DELETE FROM SubTask st WHERE st.id IN (:subTasksIds)")
		.setParameter("subTasksIds", subTasksIds).executeUpdate();
	}

	@Override
	public SubTask findSubTaskById(Long subTaskId) {
		return (SubTask) Utilities.getSingleResultOrNull(em.createQuery(
				"SELECT st FROM SubTask st WHERE st.id = :subTaskId").setParameter(
				"subTaskId", subTaskId));
	}

	@Override
	public Set<SubTask> getSubTasksByTaskId(Long taskId) {
		LinkedHashSet<SubTask> result = new LinkedHashSet<SubTask>();
		result.addAll(em.createQuery(
		"SELECT st FROM SubTask st WHERE st.parentTask.id = :taskId")
				.setParameter("taskId", taskId).getResultList());
		return result;
	}

	@Override
	public Set<SubTask> getSubTasksByUser(Long userId) {
		LinkedHashSet<SubTask> result = new LinkedHashSet<SubTask>();
		result.addAll(em.createQuery(
		"SELECT st FROM SubTask st WHERE st.lastUserActivity.id = :lastUserActivity AND st.taken = true")
				.setParameter("lastUserActivity", userId).getResultList());
		return result;
	}
	
	@Override
	public Set<SubTask> getSubTasksUnplannedByUser(Long userId) {
		LinkedHashSet<SubTask> result = new LinkedHashSet<SubTask>();
		result.addAll(em.createQuery(
		"SELECT st FROM SubTask st WHERE st.lastUserActivity.id = :lastUserActivity AND st.startingDate IS NULL AND st.endingDate IS NULL AND st.taken = true")
				.setParameter("lastUserActivity", userId).getResultList());
		return result;
	}
	
	@Override
	public Set<SubTask> getSubTasksPlannedByUser(Long userId) {
		LinkedHashSet<SubTask> result = new LinkedHashSet<SubTask>();
		result.addAll(em.createQuery(
		"SELECT st FROM SubTask st WHERE st.lastUserActivity.id = :lastUserActivity AND st.startingDate IS NOT NULL AND st.endingDate IS NOT NULL AND st.taken = true")
				.setParameter("lastUserActivity", userId).getResultList());
		return result;
	}

}
