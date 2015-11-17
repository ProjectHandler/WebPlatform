package fr.projecthandler.web;

import java.security.Principal;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import fr.projecthandler.dto.HomeContentWrapperDTO;
import fr.projecthandler.model.Event;
import fr.projecthandler.model.Task;
import fr.projecthandler.model.User;
import fr.projecthandler.service.EventService;
import fr.projecthandler.service.TaskService;
import fr.projecthandler.service.UserService;
import fr.projecthandler.session.CustomUserDetails;

@Controller
public class HomeController {

	@Autowired
	UserService userService;

	@Autowired
	TaskService taskService;

	@Autowired
	EventService eventService;

	@Autowired
	HttpSession httpSession;

	// @RequestMapping(value = "home", method = RequestMethod.GET)
	// public ModelAndView home(Principal principal) {
	// return new ModelAndView("home", null);
	// }

	@RequestMapping(value = "test", method = RequestMethod.GET)
	public void test() throws Exception { 
		throw new Exception("test");
	}
	
	@RequestMapping(value = "accessDenied", method = RequestMethod.GET)
	public ModelAndView accessDenied() {
		return new ModelAndView("accessDenied");
	}
	
	@RequestMapping(value = "404", method = RequestMethod.GET)
	public ModelAndView pageNotFound() {
		return new ModelAndView("pageNotFound");
	}
		
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public ModelAndView welcome(Principal principal) {
		Map<String, Object> myModel = new HashMap<String, Object>();

		if (principal != null) {
			CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
			User u = userService.findUserById(userDetails.getId());
			Set<Task> yesterdayTasks = taskService.getYesterdayTasksByUser(u.getId());
			Set<Task> todayTasks = taskService.getTodayTasksByUser(u.getId());
			Set<Task> tomorrowTasks = taskService.getTomorrowTasksByUser(u.getId());
			Set<Event> yesterdayEvents = eventService.getYesterdayEventsByUser(u.getId());
			Set<Event> todayEvents = eventService.getTodayEventsByUser(u.getId());
			Set<Event> tomorrowEvents = eventService.getTomorrowEventsByUser(u.getId());

			Set<HomeContentWrapperDTO> tneYesterday = new HashSet<>();
			for (Task t : yesterdayTasks)
				tneYesterday.add(new HomeContentWrapperDTO(t));
			for (Event e : yesterdayEvents)
				tneYesterday.add(new HomeContentWrapperDTO(e));
			Set<HomeContentWrapperDTO> tneToday = new HashSet<>();
			for (Task t : todayTasks)
				tneToday.add(new HomeContentWrapperDTO(t));
			for (Event e : todayEvents)
				tneToday.add(new HomeContentWrapperDTO(e));
			Set<HomeContentWrapperDTO> tneTomorrow = new HashSet<>();
			for (Task t : tomorrowTasks)
				tneTomorrow.add(new HomeContentWrapperDTO(t));
			for (Event e : tomorrowEvents)
				tneTomorrow.add(new HomeContentWrapperDTO(e));

			myModel.put("user", u);
			myModel.put("tneYesterday", tneYesterday);
			myModel.put("tneToday", tneToday);
			myModel.put("tneTomorrow", tneTomorrow);
		} else {
			return new ModelAndView("login", null);
		}
		return new ModelAndView("home", myModel);
	}
}