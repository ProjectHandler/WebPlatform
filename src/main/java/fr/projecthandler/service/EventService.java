package fr.projecthandler.service;

import java.util.List;
import java.util.Set;

import fr.projecthandler.model.Event;

public interface EventService {
	public Long saveEvent(Event newEvent);
	
	public Event findEventById(Long id);
	
	public void updateEvent(Event e);

	public void deleteEventsByIds(List<Long> EventsIdsList);

	public Set<Event> getEventsByUser(Long userId);
	
	public Set<Event> getYesterdayEventsByUser(Long userId);
	
	public Set<Event> getTodayEventsByUser(Long userId);
	
	public Set<Event> getTomorrowEventsByUser(Long userId);
}
