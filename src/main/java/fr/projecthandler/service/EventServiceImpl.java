package fr.projecthandler.service;

import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import fr.projecthandler.dao.EventDao;
import fr.projecthandler.model.Event;
import fr.projecthandler.model.User;

@Service
public class EventServiceImpl implements EventService {

	@Autowired
	EventDao eventDao;

	public Long saveEvent(Event newEvent) {
		return eventDao.saveEvent(newEvent);
	}

	public Event findEventById(Long id) {
		return eventDao.findEventById(id);
	}

	public void updateEvent(Event e) {
		eventDao.updateEvent(e);
	}

	public void deleteEventsByIds(List<Long> EventsIdsList) {
		eventDao.deleteEventsByIds(EventsIdsList);
	}

	public Set<Event> getEventsByUser(Long userId) {
		return eventDao.getEventsByUser(userId);
	}

	public Set<Event> getYesterdayEventsByUser(Long userId) {
		return eventDao.getYesterdayEventsByUser(userId);
	}

	public Set<Event> getTodayEventsByUser(Long userId) {
		return eventDao.getTodayEventsByUser(userId);
	}

	public Set<Event> getTomorrowEventsByUser(Long userId) {
		return eventDao.getTomorrowEventsByUser(userId);
	}

	public Set<User> getUserByEvent(Long eventId) {
		return eventDao.getUserByEvent(eventId);
	}
}
