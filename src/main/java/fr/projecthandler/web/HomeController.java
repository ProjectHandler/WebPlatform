package fr.projecthandler.web;

import java.text.DateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import fr.projecthandler.model.Address;
import fr.projecthandler.model.User;
import fr.projecthandler.service.UserService;

/**
 * Handles requests for the application home page.
 */
@Controller
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	@Autowired
	UserService userService;
	
	/**
	 * Simply selects the home view to render by returning its name.
	 */
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model) {
		System.out.println("Welcome home!");
		
		Date date = new Date();
		DateFormat dateFormat = DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.LONG, locale);
		
		String formattedDate = dateFormat.format(date);
		
		model.addAttribute("serverTime", formattedDate );
		
		
		User u = userService.getUserByEmail("bruce.wayne@batman.com");
		System.out.println(u.getFirstName());

		User newUser = new User();
		newUser.setFirstName("FirstName");
		newUser.setLastName("LastName");
		newUser.setPassword("Password");
		newUser.setEmail("Email");
		newUser.setAddress(null);
		userService.saveUser(newUser);
		
		
		return "home";
	}
	
}
