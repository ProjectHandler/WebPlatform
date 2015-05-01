package fr.projecthandler.dao;

import java.util.List;
import java.util.Set;

import fr.projecthandler.model.Event;

public interface EventDao {

	public Long saveEvent(Event event);

	public void updateEvent(Event event);

	public void deleteEventsByIds(List<Long> eventsIds);

	public Event findEventById(Long eventId);

	public Set<Event> getEventsByUser(Long userId);
}