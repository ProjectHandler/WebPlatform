package fr.projecthandler.web;

import java.security.Principal;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import fr.projecthandler.model.User;
import fr.projecthandler.service.UserService;
import fr.projecthandler.session.CustomUserDetails;

@Controller
public class HomeController {

	@Autowired
	UserService userService;

	@Autowired
	HttpSession httpSession;

//	@RequestMapping(value = "home", method = RequestMethod.GET)
//	public ModelAndView home(Principal principal) {
//		return new ModelAndView("home", null);
//	}

	@RequestMapping(value = "accessDenied", method = RequestMethod.GET)
	public ModelAndView accessDenied() {
		return new ModelAndView("accessDenied");
	}

	@RequestMapping(value = "/", method = RequestMethod.GET)
	public ModelAndView welcome(Principal principal) {
		Map<String, Object> myModel = new HashMap<String, Object>();
		if (principal != null) {
			CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
			
			User u = userService.findUserById(userDetails.getId());
			myModel.put("user", u);
		} else {
			return new ModelAndView("login", null);
		}
		return new ModelAndView("welcome", myModel);
	}


}