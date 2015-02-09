package fr.projecthandler.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import fr.projecthandler.dao.CalendarDao;
import fr.projecthandler.model.Calendar;
import fr.projecthandler.model.User;

@Service
public class CalendarServiceImpl implements CalendarService {

	@Autowired
	CalendarDao	calendarDao;

	@Override
	public List<Calendar> getAllTaskByUser(User user) {
		return calendarDao.getAllTaskByUser(user);
	}

	@Override
	public Calendar findTaskById(Long calendarId) {
		return findTaskById(calendarId);
	}

	@Override
	public void updateTask(Calendar calendar) {
		calendarDao.updateTask(calendar);
	}

	@Override
	public Long saveTask(Calendar calendar) {
		return calendarDao.saveTask(calendar);
	}

}
