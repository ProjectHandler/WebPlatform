package fr.projecthandler.web;

import java.security.Principal;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import fr.projecthandler.model.User;
import fr.projecthandler.service.CustomUserDetails;
import fr.projecthandler.service.UserService;

@Controller
public class AdminController {

	@Autowired
	UserService userService;

	@RequestMapping(value = "signupSendMailService", method = RequestMethod.GET)
	public ModelAndView redirectToSignupSendMailService(HttpServletRequest request, HttpServletResponse response, Principal principal) {
		Map<String, Object> myModel = new HashMap<String, Object>();

		if (principal != null) {
			CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
			
			User u = userService.findUserById(userDetails.getId());
			myModel.put("user", u);
		}

		return new ModelAndView("signupSendMailService", myModel);
	}
	
	@RequestMapping(value = "checkEmailExists", method = RequestMethod.POST)
	public @ResponseBody String checkEmailExists(HttpServletRequest request) {

		String email = request.getParameter("email");
		System.out.println("verif email : " + email);
		return "OK";
	}

	@RequestMapping(value = "admin/sendEmail", method = RequestMethod.POST)
	public String sendEmail(HttpServletRequest request, HttpServletResponse response, Principal principal) {

		System.out.println("ENFIN j'envoie: " + request.getParameter("email"));
		
		if (principal != null) {
		//	CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
		//	User u = userService.findUserById(userDetails.getId());

		}

		return "redirect:/signupSendMailService";
	}
	
}
