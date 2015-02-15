package fr.projecthandler.dao;

import java.util.List;

import fr.projecthandler.model.Calendar;
import fr.projecthandler.model.User;

public interface CalendarDao {

	public Long saveTask(Calendar calendar);
	
	public void updateTask(Calendar calendar);

	public List<Calendar> getAllTaskByUser(User user);

	public Calendar findTaskById(Long calendarId);
}
