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
import fr.projecthandler.service.MailService;
import fr.projecthandler.service.UserService;
import fr.projecthandler.session.CustomUserDetails;

@Controller
public class AdminController {

	@Autowired
	UserService userService;

	@Autowired
	MailService mailService;

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
	
	//Here we will be testing if all mail are valid;
	@RequestMapping(value = "checkEmailExists", method = RequestMethod.POST)
	public @ResponseBody String checkEmailExists(HttpServletRequest request) {
		
		/*
		 * TODO : here parse and valid for each mail	
		 */
		
		//if email not valid return KO
		
		String email = request.getParameter("email");
		System.out.println("verif email : " + email);
		return "OK";
	}

	//here we send mail with token for each user by mail
	//create user by mail and generate token then send email with token for each user
	@RequestMapping(value = "admin/sendEmail", method = RequestMethod.POST)
	public String sendEmail(HttpServletRequest request, HttpServletResponse response, Principal principal) {
		String email = request.getParameter("email");
		// for each mail
		
		/*
		 * TODO : here create user
		 */
		
		/*
		 * TODO : here create Token and save both
		 */
		
		/*
		 * TODO : here send email with url + token inside
		 */
		System.out.println("ENFIN j'envoie: " + email);
		
		mailService.sendEmail("COUCOU", email, "test", "JUSTE POUR TEST");
		
		if (principal != null) {
		//	CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
		//	User u = userService.findUserById(userDetails.getId());

		}

		return "redirect:/signupSendMailService";
	}
	
}
