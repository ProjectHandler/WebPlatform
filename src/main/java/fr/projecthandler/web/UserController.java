package fr.projecthandler.web;

import java.security.Principal;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
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
