package fr.projecthandler.test.content;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;

import fr.projecthandler.enums.AccountStatus;
import fr.projecthandler.enums.ProjectStatus;
import fr.projecthandler.enums.UserRole;
import fr.projecthandler.model.Event;
import fr.projecthandler.model.Group;
import fr.projecthandler.model.Project;
import fr.projecthandler.model.User;

public class DataProvider {

	public static User getUser1Data() {
		User user = new User();
		user.setFirstName("Robert");
		user.setLastName("Dupont");
		user.setPassword("56az4de456zaz");
		user.setUserRole(UserRole.ROLE_SIMPLE_USER);
		user.setEmail("robert.dupont478@yopmail.com");
		user.setPhone("0142215886");
		user.setMobilePhone("0654422187");
		user.setAccountStatus(AccountStatus.ACTIVE);
		user.setDailyHour("09:00pm - 10:00pm");
		user.setWorkDay("ttttttf");
		return user;
	}
	
	public static User getUser2Data() {
		User user = new User();
		user.setFirstName("Francois");
		user.setLastName("Duruy");
		user.setPassword("56az4de456zaz");
		user.setUserRole(UserRole.ROLE_ADMIN);
		user.setEmail("fr.du@yopmail.com");
		user.setPhone("0101010101");
		user.setMobilePhone("0606060606");
		user.setAccountStatus(AccountStatus.ACTIVE);
		user.setDailyHour("08:00pm - 9:00pm");
		user.setWorkDay("tttttff");
		return user;
	}
	
	public static User getUser3Data() {
		User user = new User();
		user.setFirstName("Koko");
		user.setLastName("Channel");
		user.setPassword("56az4de456zaz");
		user.setUserRole(UserRole.ROLE_SIMPLE_USER);
		user.setEmail("koko@yopmail.com");
		user.setPhone("0101010102");
		user.setMobilePhone("0606060607");
		user.setAccountStatus(AccountStatus.ACTIVE);
		user.setDailyHour("08:00pm - 9:00pm");
		user.setWorkDay("tttttff");
		return user;
	}
	
	public static Event getEventData() {
		Event event = new Event();
		event.setTitle("Event1");
		event.setDescription("Test");
		Calendar cal = Calendar.getInstance();
		cal.set(2015, 1, 1, 0, 0, 0);
		event.setStartingDate(cal.getTime());
		cal.set(2015, 1, 1, 2, 0, 0);
		event.setEndingDate(cal.getTime());
		event.setStatus("TEST");
		return event;
	}
	
	public static Event getEventWithUserData() {
		Event event = new Event();
		event.setTitle("Event1");
		event.setDescription("Test");
		Calendar cal = Calendar.getInstance();
		cal.set(2015, 1, 1, 0, 0, 0);
		event.setStartingDate(cal.getTime());
		cal.set(2015, 1, 1, 2, 0, 0);
		event.setEndingDate(cal.getTime());
		event.setStatus("TEST");
		List<User> users = new ArrayList<>();
		users.add(getUser1Data());
		users.add(getUser2Data());
		event.setUsers(users);
		return event;
	}
	
	public static Group getGroup1Data() {
		Group group = new Group();
		group.setName("Groupe 1");
		return group;
	}
	
	public static Group getGroup2Data() {
		Group group = new Group();
		group.setName("Groupe 2");
		return group;
	}
	
	public static Group getGroup3Data() {
		Group group = new Group();
		group.setName("Groupe 3");
		return group;
	}
	
	public static Project getProject1Data() {
		Project project = new Project();
		project.setName("Project test 1");
		project.setDuration(365l);
		Calendar cal = Calendar.getInstance();
		cal.set(2015, 1, 1, 0, 0, 0);
		project.setDateBegin(cal.getTime());
		cal.set(2016, 1, 1, 0, 0, 0);
		project.setDateEnd(cal.getTime());
		project.setDescription("description test 1");
		project.setProgress(0l);
		project.setStatus(ProjectStatus.ACTIVE.getValue());
		return project;
	}
	
	public static Project getProject2Data() {
		Project project = new Project();
		project.setName("Project test 2");
		project.setDuration(365l);
		Calendar cal = Calendar.getInstance();
		cal.set(2014, 1, 1, 0, 0, 0);
		project.setDateBegin(cal.getTime());
		cal.set(2015, 1, 1, 0, 0, 0);
		project.setDateEnd(cal.getTime());
		project.setDescription("description test 2");
		project.setProgress(100l);
		project.setStatus(ProjectStatus.ACTIVE.getValue());
		return project;
	}
}
