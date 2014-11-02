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

import fr.projecthandler.enums.AccountStatus;
import fr.projecthandler.enums.UserRole;
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
	UserService userService;

	@Autowired
	MailService mailService;
	
	@Autowired
	TokenService tokenService;

	// domainName and urlToGo will be merged once a conf file is made to get domain name on server start. 
	private final static String domainName = "http://localhost:8080/projecthandler/";
	private final static String urlToGo = "verifyUser?token=";
	private final static String emailSender = "Someone";
	private final static String emailTitle = "Project Handler Registration [Autogenerated email. Please, do not answer]";
	private final static String emailContent = "The following link has been sent by Project Handler administrator.\nClick to register :";

	@RequestMapping(value = "signupSendMailService", method = RequestMethod.GET)
	public ModelAndView redirectToSignupSendMailService(HttpServletRequest request, HttpServletResponse response, Principal principal) {
		// TODO CHECK IF USER IS ADMIN
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
		String email = request.getParameter("email");
		EmailValidator emailValidator = new EmailValidator();
		String[] parsedMail = email.split("[,; ]");
		StringBuilder errorMail = new StringBuilder("Invalid email(s): ");

		for (int i = 0; i < parsedMail.length; i++) {
			if (!emailValidator.validate(parsedMail[i])) {
				errorMail.append("\"");
				errorMail.append(parsedMail[i]);
				errorMail.append("\";");
			}
		}
		if (errorMail.toString().length() > 18)
			return errorMail.toString();
		return "OK";
	}

	//here we send mail with token for each user by mail
	//create user by mail and generate token then send email with token for each user
	@RequestMapping(value = "admin/sendEmail", method = RequestMethod.POST)
	public String sendEmail(HttpServletRequest request, HttpServletResponse response, Principal principal) {
		String email = request.getParameter("email");
		String[] parsedMail = email.split("[,; ]");
		
		// for each mail
		for (int i = 0; i < parsedMail.length; i++) {
			StringBuilder mailContentBuffer = new StringBuilder();
			
			//Handle user
			User user = new User();
			user.setEmail(parsedMail[i]);
			user.setAccountStatus(AccountStatus.INACTIVE);
			user.setUserRole(UserRole.ROLE_SIMPLE_USER);
			Long userId = userService.saveUser(user);
			user.setId(userId);
			
			//Handle Token
			Token token = new Token();
			token.setToken(TokenGenerator.generateToken());
			token.setTimeStamp(TokenGenerator.generateTimeStamp());
			token.setUser(user);
			tokenService.saveToken(token);
			
			mailContentBuffer.append(emailContent);
			mailContentBuffer.append(domainName);
			mailContentBuffer.append(urlToGo);
			mailContentBuffer.append(token.getToken());
			
			mailService.sendEmail(emailSender, parsedMail[i], emailTitle, mailContentBuffer.toString());
		}

		return "redirect:/signupSendMailService";
	}
	
}
