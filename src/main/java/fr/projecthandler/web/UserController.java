package fr.projecthandler.web;

import java.security.Principal;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.security.web.authentication.rememberme.PersistentTokenBasedRememberMeServices;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import fr.projecthandler.enums.Civility;
import fr.projecthandler.model.User;
import fr.projecthandler.service.UserService;

@Controller
public class UserController {

	@Autowired
	UserService userService;
	
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
	public ModelAndView redirectSignup() {
		Map<String, Object> myModel = new HashMap<String, Object>();

		myModel.put("civility", Civility.values());
		return new ModelAndView("signup", myModel);
	}

	@RequestMapping(value = "/saveUser", method = RequestMethod.GET)
	public String saveUser(Principal principal, HttpServletRequest request) {

		User u = new User();
		
		u.setFirstName(request.getParameter("firstName"));
		u.setLastName(request.getParameter("lastName"));
		u.setEmail(request.getParameter("email"));
		u.setPhone(request.getParameter("phone"));
		u.setMobilePhone(request.getParameter("mobilePhone"));
		u.setPassword(request.getParameter("password"));
		
		userService.saveUser(u);
		
		return "redirect:/";
	}
}