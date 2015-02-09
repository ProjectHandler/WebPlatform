package fr.projecthandler.service;

import java.util.List;

import fr.projecthandler.model.Calendar;
import fr.projecthandler.model.User;

public interface CalendarService {

	public List<Calendar> getAllTaskByUser(User user);

	public Calendar findTaskById(Long calendarId);

	public void updateTask(Calendar calendar);

	public Long saveTask(Calendar calendar);

}
