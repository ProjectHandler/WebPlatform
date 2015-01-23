package fr.projecthandler.web;

import java.security.Principal;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.access.annotation.Secured;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.security.web.authentication.preauth.PreAuthenticatedAuthenticationToken;
import org.springframework.security.web.authentication.rememberme.PersistentTokenBasedRememberMeServices;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import fr.projecthandler.enums.AccountStatus;
import fr.projecthandler.enums.Civility;
import fr.projecthandler.model.Token;
import fr.projecthandler.model.User;
import fr.projecthandler.service.TokenService;
import fr.projecthandler.service.UserService;
import fr.projecthandler.session.CustomUserDetails;
import fr.projecthandler.util.TokenGenerator;
import fr.projecthandler.util.Utilities;

@Controller
public class UserController {

	@Autowired
	UserService userService;

	@Autowired
	TokenService tokenService;

	@Autowired
	BCryptPasswordEncoder passwordEncoder;
	
	@Autowired
	private UserDetailsService customUserDetailsService;

	private static final Long maximumTokenValidity = 10368000l; // 2 jours ms

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
	public String invalidateSession(HttpServletResponse response,
			HttpServletRequest request) {
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

		myModel.put("civility", Civility.values());
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
				u.setCivility(Civility.findCivilityById(Integer.parseInt(civility)));
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
	
	@RequestMapping(value = "/calendar", method = RequestMethod.GET)
	public ModelAndView calendar(Principal principal) {
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
	public ModelAndView verifyUserEmail(HttpServletRequest request,	HttpServletResponse response, Principal principal) {
		Map<String, Object> myModel = new HashMap<String, Object>();
		String token = request.getParameter("token");
		logoutUser(principal, request, response);

		if (token != null && token.length() > 0) {
			User user = tokenService.findUserByToken(token);
			
			if (user == null)
				return new ModelAndView("accessDenied", null);

			myModel.put("civility", Civility.values());
			myModel.put("user", user);

			// Access denied if Token out of date.
			Token t = tokenService.findTokenByUserId(user.getId());
			if (TokenGenerator.checkTimestamp(t.getTimeStamp(),	maximumTokenValidity)) {
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
}