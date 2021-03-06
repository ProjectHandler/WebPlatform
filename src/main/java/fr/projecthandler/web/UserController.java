package fr.projecthandler.web;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URLConnection;
import java.security.Principal;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.ResourceBundle;
import java.util.Set;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.configuration.Configuration;
import org.apache.commons.configuration.PropertiesConfiguration;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.session.SessionRegistry;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.security.web.authentication.preauth.PreAuthenticatedAuthenticationToken;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.support.RequestContextUtils;

import com.google.gson.Gson;

import fr.projecthandler.annotation.CurrentUserDetails;
import fr.projecthandler.dto.CalendarDTO;
import fr.projecthandler.dto.UserDTO;
import fr.projecthandler.enums.AccountStatus;
import fr.projecthandler.enums.UserRole;
import fr.projecthandler.model.Event;
import fr.projecthandler.model.Project;
import fr.projecthandler.model.SubTask;
import fr.projecthandler.model.Task;
import fr.projecthandler.model.Token;
import fr.projecthandler.model.User;
import fr.projecthandler.service.CivilityService;
import fr.projecthandler.service.EventService;
import fr.projecthandler.service.InputAutocompleteService;
import fr.projecthandler.service.MailService;
import fr.projecthandler.service.ProjectService;
import fr.projecthandler.service.SubTaskService;
import fr.projecthandler.service.TaskService;
import fr.projecthandler.service.TokenService;
import fr.projecthandler.service.UserService;
import fr.projecthandler.session.CustomUserDetails;
import fr.projecthandler.util.TokenGenerator;
import fr.projecthandler.util.Utilities;

@Controller
public class UserController {

	private static final Log log = LogFactory.getLog(UserController.class);

	@Autowired
	SessionRegistry sessionRegistry;
	
	@Autowired
	UserService userService;

	@Autowired
	TokenService tokenService;

	@Autowired
	TaskService taskService;

	@Autowired
	SubTaskService subTaskService;

	@Autowired
	ProjectService projectService;

	@Autowired
	EventService eventService;
	
	@Autowired
	CivilityService civilityService;

	@Autowired
	BCryptPasswordEncoder passwordEncoder;

	@Autowired
	InputAutocompleteService inputAutocompleteService;
	
	@Autowired
	MailService mailService;
	
	@Autowired
	private MessageSource messageSource;

	@Autowired
	private UserDetailsService customUserDetailsService;

	@Autowired
	private LocaleResolver localeResolver;

	private static final Long maximumTokenValidity = 10368000l; // 2 jours ms

	@RequestMapping(value = "login", method = RequestMethod.GET)
	public ModelAndView login(HttpServletRequest request, HttpServletResponse response, Principal principal) {
		logoutUser(principal, request, null);
		return new ModelAndView("login");
	}

	@RequestMapping(value = "loginFailed", method = RequestMethod.GET)
	public ModelAndView loginFailed() {
		return new ModelAndView("login");
	}

	@RequestMapping(value = "logout", method = RequestMethod.GET)
	public ModelAndView logout(HttpServletRequest request, HttpServletResponse response, Principal principal) {
		logoutUser(principal, request, response);
		return new ModelAndView("login");
	}

	@RequestMapping(value = "invalidateSession", method = RequestMethod.GET)
	public String invalidateSession(HttpServletResponse response, HttpServletRequest request, Principal principal) {
		logoutUser(principal, request, null);
		return "redirect:/login";
	}
	
	public void logoutUser(Principal principal, HttpServletRequest request, HttpServletResponse response) {
		Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		if (auth != null && principal != null) {
			new SecurityContextLogoutHandler().logout(request, response, auth);
			SecurityContextHolder.getContext().setAuthentication(null);
		}
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
			u.setWorkDay(Utilities.getRequestParameter(request, "userWorkDay"));
			u.setDailyHour(Utilities.getRequestParameter(request, "userDailyHour"));
			u.setMobilePhone(Utilities.getRequestParameter(request, "mobilePhone"));

			if (isValid == true && u.getAccountStatus() != AccountStatus.ACTIVE)
				u.setAccountStatus(AccountStatus.ACTIVE);

			userService.updateUser(u);
			tokenService.deleteTokenByUserId(u.getId());

			// Refresh his session to display his information
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

	@RequestMapping(value = "/calendar/createEvent", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public void createEvent(Principal principal, HttpServletRequest request) throws IOException {
		if (principal != null) {
			CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
			if (userDetails.getUserRole() == UserRole.ROLE_ADMIN) {
				String usersConcern = Utilities.getRequestParameter(request, "usersConcern");
				String[] usersArray = usersConcern.split(",");
				List<User> users = new ArrayList<User>();
		        for(String u:usersArray) {
		        	users.add(userService.findUserById(Long.parseLong(u)));
		        }

				String title = Utilities.getRequestParameter(request, "title");
				String description = Utilities.getRequestParameter(request, "description");
				String daterange = Utilities.getRequestParameter(request, "daterange");
				String date[] = daterange.split("-", 0);
				try {
					Date startingDate = new SimpleDateFormat("dd/MM/yyyy hh:mm aa").parse(date[0]);
					Date endingDate = new SimpleDateFormat("dd/MM/yyyy hh:mm aa").parse(date[1]);

					Event event = new Event();
					event.setTitle(title);
					event.setDescription(description);
					event.setStartingDate(startingDate);
					event.setEndingDate(endingDate);
					event.setUsers(users);
					eventService.saveEvent(event);
				} catch (ParseException e) {
					log.error("error creating event", e);
				}
			}
		}
	}
	
	@RequestMapping(value = "/calendar/loadUserFromEvent", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public void loadUserFromEvent(Principal principal, HttpServletRequest request, HttpServletResponse respsonse) throws IOException {
		if (principal != null) {
			Set<User> listUser = new HashSet<User>();
			try {
				listUser = eventService.getUserByEvent(Long.parseLong(Utilities.getRequestParameter(request, "eventId")));
			} catch (Exception e) {
				e.printStackTrace();
			}
			List<UserDTO> listUsersForSelectivityOnCalendar = new ArrayList<>();
			for (User user : listUser)
				listUsersForSelectivityOnCalendar.add(new UserDTO(user));
			String jsonUserByEnvent = new Gson().toJson(listUsersForSelectivityOnCalendar);
			// Printout the JSON
			respsonse.setContentType("application/json");
			respsonse.setCharacterEncoding("UTF-8");
			respsonse.setStatus(200);
			try {
				respsonse.getWriter().write(jsonUserByEnvent);
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	@RequestMapping(value = "/calendar/updateEvent", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public void updateEvent(Principal principal, HttpServletRequest request) throws IOException {
		if (principal != null) {
			CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
			if (userDetails.getUserRole() == UserRole.ROLE_ADMIN) {
				String usersConcern = Utilities.getRequestParameter(request, "usersConcern");
				String[] usersArray = usersConcern.split(",");
				List<User> users = new ArrayList<User>();
		        for(String u:usersArray) {
		        	users.add(userService.findUserById(Long.parseLong(u)));
		        }

				Event event = eventService.findEventById(Long.parseLong(Utilities.getRequestParameter(request, "eventId")));
				String title = Utilities.getRequestParameter(request, "title");
				String description = Utilities.getRequestParameter(request, "description");
				String daterange = Utilities.getRequestParameter(request, "daterange");
				String date[] = daterange.split("-", 0);
				try {
					Date startingDate = new SimpleDateFormat("dd/MM/yyyy hh:mm aa").parse(date[0]);
					Date endingDate = new SimpleDateFormat("dd/MM/yyyy hh:mm aa").parse(date[1]);

					event.setTitle(title);
					event.setDescription(description);
					event.setStartingDate(startingDate);
					event.setEndingDate(endingDate);
					event.setUsers(users);
					eventService.updateEvent(event);
				} catch (ParseException e) {
					log.error("error updating event", e);
				}
			}
		}
	}

	@RequestMapping(value = "/calendar/deleteEvent", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public void deleteEvent(Principal principal, HttpServletRequest request) throws IOException {
		if (principal != null) {
			CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
			if (userDetails.getUserRole() == UserRole.ROLE_ADMIN) {
				List<Long> eventIds = Arrays.asList(Long.parseLong(Utilities.getRequestParameter(request, "eventId")));
				eventService.deleteEventsByIds(eventIds);
			}
		}
	}

	
	@RequestMapping(value = "/calendar/updateSubtask", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public void updateSubtask(Principal principal, HttpServletRequest request) throws IOException {
		if (principal != null) {
			CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
			SubTask subTask = subTaskService.findSubTaskByIdAndFetchUser(Long.parseLong(Utilities.getRequestParameter(request, "eventId")));
			if (subTask.isTaken() == true && userDetails.getId().equals(subTask.getLastUserActivity().getId())) {
				String title = Utilities.getRequestParameter(request, "title");
				String daterange = Utilities.getRequestParameter(request, "daterange");
				String date[] = daterange.split("-", 0);
				try {
					Date startingDate = new SimpleDateFormat("dd/MM/yyyy hh:mm aa").parse(date[0]);
					Date endingDate = new SimpleDateFormat("dd/MM/yyyy hh:mm aa").parse(date[1]);
					subTask.setDescription(title);
					subTask.setStartingDate(startingDate);
					subTask.setEndingDate(endingDate);
					subTaskService.updateSubTask(subTask);
				} catch (ParseException e) {
					log.error("error updating subtask", e);
				}
			}
		}
	}

	@RequestMapping(value = "/calendar/unplannedSubtask", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.OK)
	public void unplannedSubtask(Principal principal, HttpServletRequest request) throws IOException, ParseException {
		if (principal != null) {
			CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
			SubTask subTask = subTaskService.findSubTaskByIdAndFetchUser(Long.parseLong(Utilities.getRequestParameter(request, "subtaskId")));
			if (subTask.isTaken() == true && userDetails.getId().equals(subTask.getLastUserActivity().getId())) {
				subTask.setStartingDate(null);
				subTask.setEndingDate(null);
				subTaskService.updateSubTask(subTask);
			}
		}
	}

	@RequestMapping(value = "/calendar/calendarDetailsSubtaskUnplanned", method = RequestMethod.GET)
	@ResponseStatus(HttpStatus.OK)
	public void calendarDetailsSubtaskUnplanned(Principal principal, HttpServletRequest request, HttpServletResponse respsonse) throws IOException {
		if (principal != null) {
			CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
			User u = userService.findUserById(userDetails.getId());

			Set<SubTask> listSubTask = new HashSet<SubTask>();
			try {
				listSubTask = subTaskService.getSubTasksUnplannedByUser(u.getId());
			} catch (Exception e) {
				log.error("error in calendarDetailsSubtaskUnplanned", e);
			}

			List<CalendarDTO> listForCalendar = new ArrayList<>();
			for (SubTask subTask : listSubTask)
				listForCalendar.add(new CalendarDTO(subTask));

			// Convert FullCalendar from Java to JSON
			String jsonAppointment = new Gson().toJson(listForCalendar);
			// Printout the JSON
			respsonse.setContentType("application/json");
			respsonse.setCharacterEncoding("UTF-8");
			try {
				respsonse.getWriter().write(jsonAppointment);
			} catch (IOException e) {
				log.error("error in calendarDetailsSubtaskUnplanned for writing jsonAppointment", e);
			}
		}
	}

	@RequestMapping(value = "/calendar/calendarDetails", method = RequestMethod.GET)
	public void calendarDetails(Principal principal, HttpServletRequest request, HttpServletResponse respsonse) throws IOException {
		if (principal != null) {
			CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
			User u = userService.findUserById(userDetails.getId());

			// Get the entire list of appointments available by user
			Set<Task> listTask = new HashSet<Task>();
			Set<Event> listEvent = new HashSet<Event>();
			Set<SubTask> listSubTask = new HashSet<SubTask>();
			try {
				listTask = taskService.getTasksByUserAndFetchUsers(u.getId());
				listEvent = eventService.getEventsByUser(u.getId());
				listSubTask = subTaskService.getSubTasksPlannedByUser(u.getId());
			} catch (Exception e) {
				log.error("error getting calendar details", e);
			}
			
			// Convert appointment to FullCalendar (A class created to facilitate the JSON)
			List<CalendarDTO> listForCalendar = new ArrayList<>();
			for (Task task : listTask)
				listForCalendar.add(new CalendarDTO(task));
			for (Event event : listEvent)
				listForCalendar.add(new CalendarDTO(event));
			for (SubTask subTask : listSubTask)
				listForCalendar.add(new CalendarDTO(subTask));

			// Convert FullCalendar from Java to JSON
			String jsonAppointment = new Gson().toJson(listForCalendar);
			// Printout the JSON
			respsonse.setContentType("application/json");
			respsonse.setCharacterEncoding("UTF-8");
			try {
				respsonse.getWriter().write(jsonAppointment);
			} catch (IOException e) {
				log.error("error in calendarDetailsSubtaskUnplanned for writing jsonAppointment", e);
			}
		}
	}

	@RequestMapping(value = "/calendar", method = { RequestMethod.GET, RequestMethod.POST })
	public ModelAndView calendar(Principal principal, HttpServletRequest request) {
		Map<String, Object> myModel = new HashMap<String, Object>();

		if (principal != null) {
			CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
			User u = userService.findUserById(userDetails.getId());
			myModel.put("users", userService.getAllActiveUsers());
			myModel.put("groups", userService.getAllNonEmptyGroups());
			myModel.put("user", u);
		}

		return new ModelAndView("user/calendar", myModel);
	}

	@RequestMapping(value = "/downloadAvatar/{userId}", method = RequestMethod.GET)
	public void downloadAvatar(@PathVariable Long userId, HttpServletResponse response) {
		File avatarFile = userService.getUserAvatarFile(userId);
		Utilities.writeFileAsResponseStream(avatarFile, response);
	}

	@RequestMapping(value = "/saveAvatar", method = RequestMethod.POST)
	public String saveAvatar(Principal principal, @RequestParam MultipartFile avatar) throws Exception {
		CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
		Configuration config = new PropertiesConfiguration("spring/path.properties");
		String path = config.getString("folder.path");

		File directory = new File(new File(path, "users" + Long.toString(userDetails.getId())), "avatars");
		if (!directory.exists())
			directory.mkdirs();
		User user = userService.findUserById(userDetails.getId());
		if (user != null) {
			if (avatar.isEmpty()) {
				// delete user avatar
				File file = new File(directory, user.getAvatarFileName());
				file.delete();
				user.setAvatarFileName(null);
				userService.updateUser(user);
			} else {
				BufferedOutputStream out = null;
				String fileName = user.getAvatarFileName();
				File file = null;
				try {
					if (fileName == null) {
						final StringBuilder fileNameSB = new StringBuilder(user.getId() + "_" + UUID.randomUUID().toString());
						fileNameSB.append('.').append(FilenameUtils.getExtension(avatar.getOriginalFilename()));
						fileName = fileNameSB.toString();
					}
					// save avatar
					file = new File(directory, fileName);
					String mimeType = URLConnection.guessContentTypeFromName(file.getName());
					if (mimeType.equals("image/jpeg") || mimeType.equals("image/pjpeg") || mimeType.equals("image/x-png")
							|| mimeType.equals("image/png") || mimeType.equals("image/gif")) {
						out = new BufferedOutputStream(new FileOutputStream(file));
						out.write(avatar.getBytes());
						if (out != null) {
							out.close();
						}
						user.setAvatarFileName(fileName);
						userService.updateUser(user);
					} else {

					}
				} catch (Exception e) {
					throw new Exception("Error uploading avatar for user: " + userDetails.getId(), e);
				}
			}
		}
		return "redirect:/signup";
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
		myModel.put("message", messageSource.getMessage("projecthandler.expiredToken.signup", null, LocaleContextHolder.getLocale()));
				
		if (token != null && token.length() > 0) {
			// logout for user authenticated
			Authentication auth = SecurityContextHolder.getContext().getAuthentication();
			if (auth != null && principal != null) {
				return new ModelAndView("redirect:/logout");
			}

			User user = tokenService.findUserByToken(token);
			if (user == null)
				return new ModelAndView("expiredToken", myModel);

			myModel.put("civilityList", civilityService.getAllCivilities());
			myModel.put("user", user);

			// Access denied if Token out of date OR user already validated.
			Token t = tokenService.findTokenByUserId(user.getId());
			if (TokenGenerator.checkTimestamp(t.getTimeStamp(), maximumTokenValidity)) {
				// TODO : inform about the fact that the token expired in a
				// proper page then delete token.
				tokenService.deleteTokenByUserId(user.getId());
				return new ModelAndView("expiredToken", myModel);
			}
			user.setAccountStatus(AccountStatus.MAIL_VALIDATED);
			userService.updateUser(user);

			// login auto after mail validate
			UserDetails userDetails = customUserDetailsService.loadUserByUsername(user.getEmail());
			auth = new PreAuthenticatedAuthenticationToken(userDetails, null, userDetails.getAuthorities());
			SecurityContextHolder.getContext().setAuthentication(auth);
		} else {
			return new ModelAndView("expiredToken", myModel);
		}
		return new ModelAndView("signup", myModel);
	}

	@RequestMapping(value = "/ajax/search/{projectId}/user", method = RequestMethod.GET)
	// "@RequestParam String q" c'est quoi 'q' ???
	public @ResponseBody String userSearch(@CurrentUserDetails CustomUserDetails userDetails, @PathVariable Long projectId, @RequestParam String q) {
		if (userDetails == null) {
			return "[]";
		}
		List<Project> projectList = projectService.getProjectsByUserId(userDetails.getId());
		Project project = null;

		// Checks if the projectId corresponds to one of the user's project
		// TODO use spring permissions
		for (int i = 0; i < projectList.size(); ++i) {
			if (projectList.get(i).getId().equals(projectId)) {
				project = projectList.get(i);
			}
		}
		if (project == null) {
			return "[]";
		}

		// TODO une requète pour la recherche (enabled users seulement ?)
		List<User> userList = inputAutocompleteService.getMatchingUsers(projectService.getUsersByProjectId(projectId), q);

		return inputAutocompleteService.userListToJson(userList);
	}

	@RequestMapping(value = "/profile/viewProfileBox/{userId}", method = RequestMethod.GET)
	public ModelAndView viewProjectTasks(@CurrentUserDetails CustomUserDetails userDetails, @PathVariable Long userId) {
		Map<String, Object> myModel = new HashMap<String, Object>();

		if (userDetails == null) {
			return new ModelAndView("redirect:/");
		}

		User userToFind = userService.findUserById(userId);

		if (userToFind == null) {
			// TODO not found
			return new ModelAndView("redirect:/");
		}
		userToFind.setProjects(projectService.getProjectsByUserId(userToFind.getId()));
		myModel.put("userToFind", userToFind);
		myModel.put("user", userService.findUserById(userDetails.getId()));

		return new ModelAndView("user/profileViewBox", myModel);
	}

	@RequestMapping(value = "/profile/usersProfile", method = RequestMethod.GET)
	public ModelAndView viewProjectTasks(@CurrentUserDetails CustomUserDetails userDetails) {
		Map<String, Object> myModel = new HashMap<String, Object>();

		if (userDetails == null) {
			return new ModelAndView("redirect:/");
		}

		List<User> usersList = userService.getAllActiveUsers();

		myModel.put("usersList", usersList);
		myModel.put("user", userService.findUserById(userDetails.getId()));

		return new ModelAndView("user/usersProfileView", myModel);
	}

	@RequestMapping(value = "user/draft/get", method = RequestMethod.GET)
	public @ResponseBody String getUserDraftMessage(Principal principal) {
		if (principal != null) {
			try {
				CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
				User user = userService.findUserById(userDetails.getId());
				return user.getDraftMessage();
			} catch (Exception e) {
				log.error("error getting draft", e);
			}
		}
		return "KO";
	}

	@RequestMapping(value = "user/draft/save", method = RequestMethod.POST)
	public @ResponseBody String saveUserDraftMessage(Principal principal, @RequestParam("draftMessage") String draftMessage) {
		if (principal != null) {
			User user = null;
			try {
				CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
				user = userService.findUserById(userDetails.getId());
				user.setDrafMessage(draftMessage);
				userService.updateUser(user);
				return "OK";
			} catch (Exception e) {
				log.error("error saving draft", e);
			}
		}
		return "KO";
	}
	
	@RequestMapping(value = "forgotPassword", method = RequestMethod.GET)
	public ModelAndView forgotPassword(HttpServletRequest request, HttpServletResponse response, Principal principal) {
		return new ModelAndView("forgotPassword");
	}
	
	@RequestMapping(value = "sendResetPassword", method = RequestMethod.POST)
	public ModelAndView resetPassword(HttpServletRequest request, HttpServletResponse response, Principal principal, @RequestParam("email") String email) {
		User user = userService.getUserByEmail(email);
		
		if (user != null && user.getAccountStatus() == AccountStatus.ACTIVE) {
			Token token = new Token();
			token.setToken(TokenGenerator.generateToken());
			token.setTimeStamp(TokenGenerator.generateTimeStamp());
			token.setUser(user);
			tokenService.saveToken(token);
			
			StringBuilder url = new StringBuilder();
			String serverName = request.getServerName();
			url.append(request.getScheme()).append("://").append(serverName);
			
			int serverPort = request.getServerPort();
			if ((serverPort != 80) && (serverPort != 443))
				url.append(":").append(serverPort);
			
			url.append(request.getContextPath()).append("/resetPassword?token=" + token.getToken());
			
			
			mailService.sendEmailRestPassword(user, url.toString());
		}
		return new ModelAndView("login");
	}
	
	@RequestMapping(value = "/resetPassword", method = RequestMethod.GET)
	public ModelAndView resetPassword(HttpServletRequest request, HttpServletResponse response, Principal principal) {
		Map<String, Object> myModel = new HashMap<String, Object>();
		String token = request.getParameter("token");
		myModel.put("message", messageSource.getMessage("projecthandler.expiredToken.forgotPassword", null, LocaleContextHolder.getLocale()));
		
		if (token != null && token.length() > 0) {
			// logout for user authenticated
			Authentication auth = SecurityContextHolder.getContext().getAuthentication();
			if (auth != null && principal != null)
				return new ModelAndView("redirect:/logout");
			
			User user = tokenService.findUserByToken(token);
			if (user == null)
				return new ModelAndView("expiredToken", myModel);
			
			myModel.put("user", user);
			myModel.put("isPasswordChanged", false);
			
			// Access denied if Token out of date OR user already validated.
			Token t = tokenService.findTokenByUserId(user.getId());
			if (TokenGenerator.checkTimestamp(t.getTimeStamp(), maximumTokenValidity)) {
				tokenService.deleteTokenByUserId(user.getId());
				return new ModelAndView("expiredToken", myModel);
			}
			
			UserDetails userDetails = customUserDetailsService.loadUserByUsername(user.getEmail());
			auth = new PreAuthenticatedAuthenticationToken(userDetails, null, userDetails.getAuthorities());
			SecurityContextHolder.getContext().setAuthentication(auth);
		} else {
			return new ModelAndView("expiredToken", myModel);
		}
		
		return new ModelAndView("user/changePassword", myModel);
	}

	@Transactional
	@RequestMapping(value = "profile/changeLanguage", method = RequestMethod.POST)
	public @ResponseBody String resetPassword(HttpServletRequest request, HttpServletResponse response, @CurrentUserDetails CustomUserDetails userDetails, @RequestParam(value="locale") String localeString) {
		try {
			User u = userService.findUserById(userDetails.getId());
			Locale locale = null;

			try {
				locale = StringUtils.parseLocaleString(localeString);
			} catch (IllegalArgumentException e) {
				// invalid locale string
				return ("KO");
			}
			// Check if the locale is valid by trying to get the bundle for this locale.
			// If the bundle doesn't exist, an exception will be thrown.
			// TODO use validator ?
			// TODO create property basename in configuration
			if (ResourceBundle.getBundle("messages/messages", locale) == null)
				return "KO";
			u.setLocale(locale);
			userService.saveUser(u);
			// TODO move to local resolver
			userDetails.setLocale(locale);
		} catch (Exception e) {
			log.error("changeLanguage error", e);
			return ("KO");
		}
		return "";
	}
}