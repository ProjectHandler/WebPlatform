package fr.projecthandler.dao;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import fr.projecthandler.model.Event;
import fr.projecthandler.util.DateHelper;
import fr.projecthandler.util.Utilities;

@Component
public class EventDaoImpl extends AbstractDao implements EventDao {

	@Override
	@Transactional
	public void updateEvent(Event event) {
		em.merge(event);
	}

	@Override
	@Transactional
	public Long saveEvent(Event event) {
		em.persist(event);
		return event.getId();
	}

	@Override
	@Transactional
	public void deleteEventsByIds(List<Long> eventsIds) {
		em.createQuery("DELETE FROM Event t WHERE t.id IN (:eventsIds)").setParameter("eventsIds", eventsIds).executeUpdate();
	}

	@Override
	public Event findEventById(Long eventId) {
		return (Event) Utilities
				.getSingleResultOrNull(em.createQuery("SELECT t FROM Event t WHERE t.id = :eventId").setParameter("eventId", eventId));
	}

	@Override
	public Set<Event> getEventsByUser(Long userId) {
		Set<Event> result = new HashSet<Event>();
		result.addAll(em.createQuery("SELECT e FROM Event e JOIN FETCH e.users u WHERE :userId IN (u.id)").setParameter("userId", userId)
				.getResultList());
		return result;
	}

	@Override
	public Set<Event> getYesterdayEventsByUser(Long userId) {
		Set<Event> result = new HashSet<Event>();
		StringBuilder sb = new StringBuilder();
		sb.append("SELECT e FROM Event e JOIN e.users u WHERE :userId IN (u.id) AND e.startingDate BETWEEN '");
		sb.append(DateHelper.getYesterdayDate("yyyy-MM-dd"));
		sb.append(" 00:00:00' AND '");
		sb.append(DateHelper.getYesterdayDate("yyyy-MM-dd"));
		sb.append(" 23:59:59'");
		result.addAll(em.createQuery(sb.toString()).setParameter("userId", userId).getResultList());
		return result;
	}

	@Override
	public Set<Event> getTodayEventsByUser(Long userId) {
		Set<Event> result = new HashSet<Event>();
		StringBuilder sb = new StringBuilder();
		sb.append("SELECT e FROM Event e JOIN e.users u WHERE :userId IN (u.id) AND e.startingDate BETWEEN '");
		sb.append(DateHelper.getTodayDate("yyyy-MM-dd"));
		sb.append(" 00:00:00' AND '");
		sb.append(DateHelper.getTodayDate("yyyy-MM-dd"));
		sb.append(" 23:59:59'");
		result.addAll(em.createQuery(sb.toString()).setParameter("userId", userId).getResultList());
		return result;
	}

	@Override
	public Set<Event> getTomorrowEventsByUser(Long userId) {
		Set<Event> result = new HashSet<Event>();
		StringBuilder sb = new StringBuilder();
		sb.append("SELECT e FROM Event e JOIN e.users u WHERE :userId IN (u.id) AND e.startingDate BETWEEN '");
		sb.append(DateHelper.getTomorrowDate("yyyy-MM-dd"));
		sb.append(" 00:00:00' AND '");
		sb.append(DateHelper.getTomorrowDate("yyyy-MM-dd"));
		sb.append(" 23:59:59'");
		result.addAll(em.createQuery(sb.toString()).setParameter("userId", userId).getResultList());
		return result;
	}
}
