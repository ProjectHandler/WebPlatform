package fr.projecthandler.dao;

import java.util.List;

import org.springframework.stereotype.Component;

import fr.projecthandler.model.Calendar;
import fr.projecthandler.model.User;
import fr.projecthandler.util.Utilities;

@Component
public class CalendarDaoImpl extends AbstractDao implements CalendarDao {

	public Long saveTask(Calendar calendar) {
		em.persist(calendar);
		return calendar.getId();
	}

	public void updateTask(Calendar calendar) {
		em.merge(calendar);
	}
	
	public List<Calendar> getAllTaskByUser(User user) {
		return (List<Calendar>)em.createQuery("SELECT c FROM Calendar c WHERE c.user.id =:userId")
				.setParameter("userId", user.getId()).getResultList();
	}

	public Calendar findTaskById(Long calendarId) {
		return (Calendar) Utilities.getSingleResultOrNull(em.createQuery("SELECT c FROM Calendar c WHERE c.id = :calendarId")
				.setParameter("calendarId", calendarId));
	}
}
