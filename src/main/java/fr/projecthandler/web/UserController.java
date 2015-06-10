package fr.projecthandler.web;

import java.io.IOException;
import java.security.Principal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.security.web.authentication.preauth.PreAuthenticatedAuthenticationToken;
import org.springframework.security.web.authentication.rememberme.PersistentTokenBasedRememberMeServices;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;

import fr.projecthandler.annotation.CurrentUserDetails;
import fr.projecthandler.dto.CalendarDTO;
import fr.projecthandler.enums.AccountStatus;
import fr.projecthandler.enums.UserRole;
import fr.projecthandler.model.Event;
import fr.projecthandler.model.Project;
import fr.projecthandler.model.Task;
import fr.projecthandler.model.Token;
import fr.projecthandler.model.User;
import fr.projecthandler.service.CivilityService;
import fr.projecthandler.service.EventService;
import fr.projecthandler.service.InputAutocompleteService;
import fr.projecthandler.service.ProjectService;
import fr.projecthandler.service.TaskService;
import fr.projecthandler.service.TokenService;
import fr.projecthandler.service.UserService;
import fr.projecthandler.session.CustomUserDetails;
import fr.projecthandler.util.TokenGenerator;
import fr.projecthandler.util.Utilities;

@Controller
public class UserController {

	@Autowired
	UserService					userService;

	@Autowired
	TokenService				tokenService;

	@Autowired
	TaskService 				taskService;

	@Autowired
	ProjectService				projectService;
	
	@Autowired
	EventService				eventService;

	@Autowired
	CivilityService				civilityService;

	@Autowired
	BCryptPasswordEncoder		passwordEncoder;

	@Autowired
	InputAutocompleteService	inputAutocompleteService;

	@Autowired
	private UserDetailsService	customUserDetailsService;

	private static final Long	maximumTokenValidity	= 10368000l;	// 2 jours ms

	@RequestMapping(value = "login", method = RequestMethod.GET)
	public ModelAndView login(HttpServletRequest request, HttpServletResponse response, Principal principal) {
		Map<String, Object> myModel = new HashMap<String, Object>();
		logoutUser(principal, request, response);

		return new ModelAndView("login", myModel);
	}

	public void logoutUser(Principal principal, HttpServletRequest request, HttpServletResponse response) {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		if (auth != null && principal != null) {
			new SecurityContextLogoutHandler().logout(request, response, auth);
			new PersistentTokenBasedRememberMeServices(null, null, null).logout(request, response, auth);
		}
	}

	@RequestMapping(value = "loginFailed", method = RequestMethod.GET)
	public ModelAndView loginFailed() {
		Map<String, Object> myModel = new HashMap<String, Object>();
		myModel.put("Message", "Identifiant ou mot de passe incorrect.");
		return new ModelAndView("login", myModel);
	}

	@RequestMapping(value = "logout", method = RequestMethod.GET)
	public ModelAndView logout() {
		Map<String, Object> myModel = new HashMap<String, Object>();

		return new ModelAndView("login", myModel);
	}

	@RequestMapping(value = "invalidateSession", method = RequestMethod.GET)
	public String invalidateSession(HttpServletResponse response, HttpServletRequest request) {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		if (auth != null) {
			new SecurityContextLogoutHandler().logout(request, response, auth);
			new PersistentTokenBasedRememberMeServices(null, null, null).logout(request, response, auth);
		}
		return "redirect:/login";
	}

	@RequestMapping(value = "/signup", method = RequestMethod.GET)
	public ModelAndView redirectSignup(Principal principal) {
		Map<String, Object> myModel = new HashMap<String, Object>();

		if (principal != null) {
			CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
			User u = userService.findUserById(userDetails.getId());
			myModel.put("user", u);
		}

		myModel.put("civilityList", civilityService.getAllCivilities());

		return new ModelAndView("signup", myModel);
	}
	
	@RequestMapping(value = "/saveUser", method = RequestMethod.POST)
	public String saveUser(Principal principal, HttpServletRequest request) {
		if (principal != null) {
			Boolean isValid = true;
			CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
			User u = userService.findUserById(userDetails.getId());

			// mandatory information
			String civility = Utilities.getRequestParameter(request, "civility");
			if (civility != null && civility.length() > 0) {
				u.setCivility(civilityService.findCivilityById(Long.parseLong(civility)));
			} else
				isValid = false;
			String firstName = Utilities.getRequestParameter(request, "firstName");
			if (firstName != null && firstName.length() > 0) {
				u.setFirstName(firstName);
			} else
				isValid = false;
			String lastName = Utilities.getRequestParameter(request, "lastName");
			if (lastName != null && lastName.length() > 0) {
				u.setLastName(lastName);
			} else
				isValid = false;
			String phone = Utilities.getRequestParameter(request, "phone");
			if (phone != null && phone.length() > 0) {
				u.setPhone(phone);
			} else
				isValid = false;
			String password = Utilities.getRequestParameter(request, "password");
			if (u.getAccountStatus() != AccountStatus.ACTIVE && password != null && password.length() > 0) {
				u.setPassword(passwordEncoder.encode(password));
			} else if (u.getPassword() == null || u.getPassword().length() == 0)
				isValid = false;

			// not required information
			u.setMobilePhone(Utilities.getRequestParameter(request, "mobilePhone"));

			if (isValid == true && u.getAccountStatus() != AccountStatus.ACTIVE)
				u.setAccountStatus(AccountStatus.ACTIVE);

			userService.updateUser(u);
			tokenService.deleteTokenByUserId(u.getId());

			//Refresh his session to display his information
			CustomUserDetails newUserDetails = (CustomUserDetails) customUserDetailsService.loadUserByUsername(u.getEmail());
			Authentication auth = new PreAuthenticatedAuthenticationToken(newUserDetails, null, newUserDetails.getAuthorities());
			SecurityContextHolder.getContext().setAuthentication(auth);
		}

		return "redirect:/";
	}
	

	@RequestMapping(value = "/changePassword", method = RequestMethod.GET)
	public ModelAndView changePassword(Principal principal) {
		Map<String, Object> myModel = new HashMap<String, Object>();

		if (principal != null) {
			CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
			User u = userService.findUserById(userDetails.getId());

			myModel.put("user", u);
			myModel.put("isPasswordChanged", false);
		}
		
		return new ModelAndView("user/changePassword", myModel);
	}
	
	@RequestMapping(value = "/createEvent", method = RequestMethod.POST)
	public ModelAndView createEvent(Principal principal, HttpServletRequest request) throws IOException {
		Map<String, Object> myModel = new HashMap<String, Object>();
		if (principal != null) {
			CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
			if (userDetails.getUserRole() == UserRole.ROLE_ADMIN) {
				User u = userService.findUserById(userDetails.getId());
				List<User> users = new ArrayList<User>();
				users.add(u);
				
				String title = Utilities.getRequestParameter(request, "title");
				String description = Utilities.getRequestParameter(request, "description");
				String daterange = Utilities.getRequestParameter(request, "daterange");
				String date[] = daterange.split("-", 0);
				try {
					Date startingDate = new SimpleDateFormat("dd/MM/yyyy hh:mm").parse(date[0]);
					Date endingDate = new SimpleDateFormat("dd/MM/yyyy hh:mm").parse(date[1]);
					
					Event event = new Event();
					event.setTitle(title);
					event.setDescription(description);
					event.setStartingDate(startingDate);
					event.setEndingDate(endingDate);
					event.setUsers(users);
					eventService.saveEvent(event);
				} catch (ParseException e) {
					e.printStackTrace();
				}
			}
		}
		return new ModelAndView("user/calendar", myModel);
	}
	
	

	@RequestMapping(value = "/calendarDetails", method = RequestMethod.GET)
	public void calendarDetails(Principal principal, HttpServletRequest request, HttpServletResponse respsonse) throws IOException {
		if (principal != null) {
			CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
			User u = userService.findUserById(userDetails.getId());

			//Get the entire list of appointments available by user
			Set<Task> listTask = new HashSet<Task>();
			Set<Event> listEvent = new HashSet<Event>();
			try {
				listTask = taskService.getTasksByUserAndFetchUsers(u.getId());
				listEvent = eventService.getEventsByUser(u.getId());
			} catch (Exception e) {
				e.printStackTrace();
			}
			//Convert appointment to FullCalendar (A class I created to facilitate the JSON)
			List<CalendarDTO> listForCalendar = new ArrayList<>();
			for (Task task : listTask)
				listForCalendar.add(new CalendarDTO(task));
			for (Event event : listEvent)
				listForCalendar.add(new CalendarDTO(event));
			
			//Convert FullCalendar from Java to JSON
			String jsonAppointment = new Gson().toJson(listForCalendar);
			//Printout the JSON
			respsonse.setContentType("application/json");
			respsonse.setCharacterEncoding("UTF-8");
			try {
				respsonse.getWriter().write(jsonAppointment);
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	@RequestMapping(value = "/calendar", method = RequestMethod.GET)
	public ModelAndView calendar(Principal principal, HttpServletRequest request) {
		Map<String, Object> myModel = new HashMap<String, Object>();

		if (principal != null) {
			CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
			User u = userService.findUserById(userDetails.getId());
			myModel.put("user", u);
		}

		return new ModelAndView("user/calendar", myModel);
	}

	@RequestMapping(value = "/changePassword", method = RequestMethod.POST)
	public ModelAndView changePassword(Principal principal, HttpServletRequest request) {
		Map<String, Object> myModel = new HashMap<String, Object>();

		if (principal != null) {
			CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
			User u = userService.findUserById(userDetails.getId());
			u.setPassword(passwordEncoder.encode(Utilities.getRequestParameter(request, "password")));

			userService.updateUser(u);
			myModel.put("user", u);
			myModel.put("isPasswordChanged", true);
		}

		return new ModelAndView("user/changePassword", myModel);	
	}
	
	// TODO : CLEAN CODE
	@RequestMapping(value = "/verifyUser", method = RequestMethod.GET)
	public ModelAndView verifyUserEmail(HttpServletRequest request, HttpServletResponse response, Principal principal) {
		Map<String, Object> myModel = new HashMap<String, Object>();
		String token = request.getParameter("token");
		
		if (token != null && token.length() > 0) {
			User user = tokenService.findUserByToken(token);
			if (user == null)
				return new ModelAndView("accessDenied", null);

			myModel.put("civilityList", civilityService.getAllCivilities());
			myModel.put("user", user);

			// Access denied if Token out of date.
			Token t = tokenService.findTokenByUserId(user.getId());
			if (TokenGenerator.checkTimestamp(t.getTimeStamp(), maximumTokenValidity)) {
				// TODO : inform about the fact that the token expired in a
				// proper page then delete token.
				tokenService.deleteTokenByUserId(user.getId());
				return new ModelAndView("accessDenied", null);
			}
			user.setAccountStatus(AccountStatus.MAIL_VALIDATED);
			userService.updateUser(user);

			// login auto after mail validate
			UserDetails userDetails = customUserDetailsService.loadUserByUsername(user.getEmail());
			Authentication auth = new PreAuthenticatedAuthenticationToken(userDetails, null, userDetails.getAuthorities());
			SecurityContextHolder.getContext().setAuthentication(auth);
		}
		return new ModelAndView("signup", myModel);
	}

	@RequestMapping(value = "/ajax/search/{projectId}/user", method = RequestMethod.GET)
	//"@RequestParam String q" c'est quoi 'q' ???
	public @ResponseBody String userSearch(@CurrentUserDetails CustomUserDetails userDetails, @PathVariable Long projectId, @RequestParam String q) {
		if (userDetails == null) {
			return "[]";
		}
		List<Project> projectList = projectService.getProjectsByUserId(userDetails.getId());
		Project project = null;

		// Checks if the projectId corresponds to one of the user's project
		// TODO use spring permissions
		for (int i = 0; i < projectList.size(); ++i) {
			if (projectList.get(i).getId() == projectId) {
				project = projectList.get(i);
			}
		}
		if (project == null) {
			return "[]";
		}

		//TODO une requète pour la recherche (enabled users seulement ?)
		List<User> userList = inputAutocompleteService.getMatchingUsers(projectService.getUsersByProjectId(projectId), q);

		return inputAutocompleteService.userListToJson(userList);
	}
}