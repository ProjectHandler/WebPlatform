package fr.projecthandler.web;

import java.security.Principal;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.ResourceBundle;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import fr.projecthandler.enums.AccountStatus;
import fr.projecthandler.enums.UserRole;
import fr.projecthandler.model.Group;
import fr.projecthandler.model.Token;
import fr.projecthandler.model.User;
import fr.projecthandler.service.MailService;
import fr.projecthandler.service.TokenService;
import fr.projecthandler.service.UserService;
import fr.projecthandler.session.CustomUserDetails;
import fr.projecthandler.util.EmailValidator;
import fr.projecthandler.util.TokenGenerator;

@Controller
public class AdminController {

	@Autowired
	UserService					userService;

	@Autowired
	MailService					mailService;

	@Autowired
	TokenService				tokenService;

	@RequestMapping(value = "admin/signupSendMailService", method = RequestMethod.GET)
	public ModelAndView redirectToSignupSendMailService(HttpServletRequest request, HttpServletResponse response, Principal principal) {
		Map<String, Object> myModel = new HashMap<String, Object>();

		if (principal != null) {
			CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
			if (userDetails.getUserRole() != UserRole.ROLE_ADMIN)
				return new ModelAndView("accessDenied", null);

			User u = userService.findUserById(userDetails.getId());
			myModel.put("user", u);
		} else
			return new ModelAndView("accessDenied", null);

		return new ModelAndView("admin/signupSendMailService", myModel);
	}

	// Here we will be testing if all mail are valid;
	@RequestMapping(value = "checkEmailExists", method = RequestMethod.POST)
	public @ResponseBody String checkEmailExists(HttpServletRequest request) {
		String email = request.getParameter("email");
		EmailValidator emailValidator = new EmailValidator();
		String[] parsedMail = email.split("[,; ]");
		StringBuilder errorMail = new StringBuilder("Invalid email(s): ");

		for (int i = 0; i < parsedMail.length; i++) {
			if (!emailValidator.validate(parsedMail[i])) {
				errorMail.append("\"");
				errorMail.append(parsedMail[i]);
				errorMail.append("\";");
			} else if (userService.getUserByEmail(parsedMail[i]) != null) {
				errorMail.append("L'email :" + parsedMail[i] + " existe déjà.");
			} else if (parsedMail.length > 1)
				errorMail.append("L'email :" + parsedMail[i] + " est correcte.");
		}
		if (errorMail.toString().length() > 18)
			return errorMail.toString();
		return "OK";
	}

	private String buildTokenUrl(HttpServletRequest request, User user, Token token) {
		StringBuilder url = new StringBuilder();
		String serverName = request.getServerName();
		url.append(request.getScheme()).append("://").append(serverName);

		int serverPort = request.getServerPort();
		if ((serverPort != 80) && (serverPort != 443)) {
			url.append(":").append(serverPort);
		}
		url.append(request.getContextPath()).append("/verifyUser?token=" + token.getToken());
		return url.toString();
	}

	// here we send mail with token for each user by mail
	// create user by mail and generate token then send email with token for
	// each user
	@RequestMapping(value = "admin/sendEmail", method = RequestMethod.POST)
	public String sendEmail(HttpServletRequest request, HttpServletResponse response, Principal principal) {
		if (principal != null) {
			CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
			if (userDetails.getUserRole() != UserRole.ROLE_ADMIN)
				return "redirect:/accessDenied";
		} else
			return "redirect:/accessDenied";

		String email = request.getParameter("email");
		String[] parsedMail = email.split(";");

		// for each mail
		for (int i = 0; i < parsedMail.length; i++) {
			// Handle user
			User user = new User();
			user.setEmail(parsedMail[i]);
			user.setAccountStatus(AccountStatus.INACTIVE);
			user.setUserRole(UserRole.ROLE_SIMPLE_USER);
			userService.saveUser(user);

			// Handle Token
			Token token = new Token();
			token.setToken(TokenGenerator.generateToken());
			token.setTimeStamp(TokenGenerator.generateTimeStamp());
			token.setUser(user);
			tokenService.saveToken(token);
			mailService.sendEmailUserCreation(user, buildTokenUrl(request, user, token));
		}
		return "redirect:/admin/signupSendMailService";
	}

	@RequestMapping(value = "admin/users_management", method = RequestMethod.GET)
	public ModelAndView userManagment(HttpServletRequest request, HttpServletResponse response, Principal principal) {
		if (principal != null) {
			CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
			if (userDetails.getUserRole() != UserRole.ROLE_ADMIN)
				return new ModelAndView("accessDenied", null);
		} else
			return new ModelAndView("accessDenied", null);

		Map<String, Object> myModel = new HashMap<String, Object>();

		myModel.put("users", userService.getAllUsers());
		myModel.put("user_role", UserRole.values());
		myModel.put("account_status", AccountStatus.values());
		myModel.put("groups", userService.getAllGroups());
		return new ModelAndView("admin/users_management", myModel);
	}

	@RequestMapping(value = "admin/users_management/changeRole", method = RequestMethod.GET)
	public @ResponseBody String changeRole(Principal principal, @RequestParam("userId") String userId, @RequestParam("role") String role) {
		if (principal != null) {
			CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
			if (userDetails.getUserRole() != UserRole.ROLE_ADMIN)
				return "redirect:/accessDenied";
		} else
			return "redirect:/accessDenied";
		Locale locale = Locale.FRANCE;
		ResourceBundle bundle = ResourceBundle.getBundle("messages/messages", locale);
		try {
			User user = userService.findUserById(Long.parseLong(userId));
			//check number of administrator
			if (user.getUserRole() == UserRole.ROLE_ADMIN) {
				List<User> usersAdmin = userService.getUsersByRole(UserRole.ROLE_ADMIN);
				if (usersAdmin.size() <= 1)
					return "KO:" + bundle.getString("projecthandler.admin.error.deleteAllAdmin");
			}
			user.setUserRole(UserRole.valueOf(role));
			userService.updateUser(user);
			return "OK";
		} catch (Exception e) {
			e.printStackTrace();
			return "KO:" + bundle.getString("projecthandler.admin.error.unexpectedError");
		}
	}

	@RequestMapping(value = "admin/users_management/changeStatus", method = RequestMethod.GET)
	public @ResponseBody String changeStatus(Principal principal, @RequestParam("userId") String userId, @RequestParam("status") String status) {
		if (principal != null) {
			CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
			if (userDetails.getUserRole() != UserRole.ROLE_ADMIN)
				return "redirect:/accessDenied";
		} else
			return "redirect:/accessDenied";
		Locale locale = Locale.FRANCE;
		ResourceBundle bundle = ResourceBundle.getBundle("messages/messages", locale);
		try {
			User user = userService.findUserById(Long.parseLong(userId));
			//check number of administrator
			if (user.getUserRole() == UserRole.ROLE_ADMIN) {
				List<User> usersAdmin = userService.getUsersByRole(UserRole.ROLE_ADMIN);
				if (usersAdmin.size() <= 1)
					return "KO:" + bundle.getString("projecthandler.admin.error.deleteAllAdmin");
			}
			user.setAccountStatus(AccountStatus.valueOf(status));
			userService.updateUser(user);
			return "OK";
		} catch (Exception e) {
			e.printStackTrace();
			return "KO:" + bundle.getString("projecthandler.admin.error.unexpectedError");
		}
	}

	@RequestMapping(value = "admin/users_management/delete", method = RequestMethod.GET)
	public @ResponseBody String deleteUser(Principal principal, @RequestParam("userId") String userId) {
		if (principal != null) {
			CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
			if (userDetails.getUserRole() != UserRole.ROLE_ADMIN)
				return "redirect:/accessDenied";
		} else
			return "redirect:/accessDenied";
		Locale locale = Locale.FRANCE;
		ResourceBundle bundle = ResourceBundle.getBundle("messages/messages", locale);
		try {
			User user = userService.findUserById(Long.parseLong(userId));
			//check number of administrator
			if (user.getUserRole() == UserRole.ROLE_ADMIN) {
				List<User> usersAdmin = userService.getUsersByRole(UserRole.ROLE_ADMIN);
				if (usersAdmin.size() <= 1)
					return "KO:" + bundle.getString("projecthandler.admin.error.deleteAllAdmin");
			}
			tokenService.deleteTokenByUserId(user.getId());
			userService.deleteUserByIds(Arrays.asList(Long.parseLong(userId)));
			return "OK";
		} catch (Exception e) {
			e.printStackTrace();
			return "KO:" + bundle.getString("projecthandler.admin.error.unexpectedError");
		}
	}

	@RequestMapping(value = "admin/users_management/reSendEmail", method = RequestMethod.GET)
	public @ResponseBody String reSendEmailToUser(Principal principal, HttpServletRequest request, @RequestParam("userId") String userId) {
		if (principal != null) {
			CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
			if (userDetails.getUserRole() != UserRole.ROLE_ADMIN)
				return "redirect:/accessDenied";
		} else
			return "redirect:/accessDenied";

		try {
			User user = userService.findUserById(Long.parseLong(userId));
			tokenService.deleteTokenByUserId(user.getId());

			// Handle Token
			Token token = new Token();
			token.setToken(TokenGenerator.generateToken());
			token.setTimeStamp(TokenGenerator.generateTimeStamp());
			token.setUser(user);
			tokenService.saveToken(token);
			mailService.sendEmailUserCreation(user, buildTokenUrl(request, user, token));
			return "OK";
		} catch (Exception e) {
			e.printStackTrace();
			return "KO";
		}
	}

	@RequestMapping(value = "admin/groups_management", method = RequestMethod.GET)
	public ModelAndView groupsManagment(HttpServletRequest request, HttpServletResponse response, Principal principal) {
		if (principal != null) {
			CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
			if (userDetails.getUserRole() != UserRole.ROLE_ADMIN)
				return new ModelAndView("accessDenied", null);
		} else
			return new ModelAndView("accessDenied", null);

		Map<String, Object> myModel = new HashMap<String, Object>();
		List<Group> groups = userService.getAllGroups();
		myModel.put("groups", groups);
		return new ModelAndView("admin/groups_management", myModel);
	}

	@RequestMapping(value = "admin/groups_management/create", method = RequestMethod.GET)
	public @ResponseBody String createGroup(Principal principal, @RequestParam("groupName") String groupName) {
		if (principal != null) {
			CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
			if (userDetails.getUserRole() != UserRole.ROLE_ADMIN)
				return "redirect:/accessDenied";
		} else
			return "redirect:/accessDenied";

		return userService.createGroup(groupName);
	}

	@RequestMapping(value = "admin/groups_management/delete", method = RequestMethod.GET)
	public @ResponseBody String deleteGroup(Principal principal, @RequestParam("groupId") String groupId) {
		if (principal != null) {
			CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
			if (userDetails.getUserRole() != UserRole.ROLE_ADMIN)
				return "redirect:/accessDenied";
		} else
			return "redirect:/accessDenied";

		try {
			userService.deleteGroupById(Long.parseLong(groupId));
			return "OK";
		} catch (Exception e) {
			e.printStackTrace();
			return "KO";
		}
	}

	@RequestMapping(value = "admin/users_management/changeGroup", method = RequestMethod.GET)
	public @ResponseBody String changeGroup(Principal principal, @RequestParam("userId") String userId, @RequestParam("groupId") String groupId, @RequestParam("action") String action) {
		if (principal != null) {
			CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
			if (userDetails.getUserRole() != UserRole.ROLE_ADMIN)
				return "redirect:/accessDenied";
		} else
			return "redirect:/accessDenied";

		try {
			userService.changeGroup(Long.parseLong(userId), Long.parseLong(groupId), action);
			return "OK";
		} catch (Exception e) {
			e.printStackTrace();
			return "KO";
		}
	}
}
