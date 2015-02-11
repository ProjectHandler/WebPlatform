package fr.projecthandler.web;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import fr.projecthandler.dao.ProjectDao;
import fr.projecthandler.enums.UserRole;
import fr.projecthandler.model.Project;
import fr.projecthandler.model.Ticket;
import fr.projecthandler.model.User;
import fr.projecthandler.service.TicketService;
import fr.projecthandler.service.UserService;
import fr.projecthandler.session.CustomUserDetails;
import fr.projecthandler.util.Utilities;

@Controller
@RequestMapping("/ticket")
public class TicketController {

	@Autowired
	UserService userService;

	@Autowired
	TicketService ticketService;
	
	@Autowired
	HttpSession httpSession;
	
	@Autowired
	ProjectDao projectService;

	@RequestMapping(value = "/new", method = RequestMethod.GET)
	public ModelAndView addTicket(Principal principal) {
		Map<String, Object> myModel = new HashMap<String, Object>();
		Ticket ticket = new Ticket();
		
		if (principal != null) {
			CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
			
			if (userDetails.getUserRole() != UserRole.ROLE_ADMIN)
				return new ModelAndView("accessDenied", null);

			User u = userService.findUserById(userDetails.getId());
			List<Project> projectList = projectService.getAllProjects();
			myModel.put("user", u);
			myModel.put("ticket", ticket);
			myModel.put("projectList", projectList);

//			ticket.setUser(u);
//			ticket.setTitle("Mon Titre");
//			ticket.setText("Lazn azoidj azdozn azoidj azdoen azoidj azdo.");
//			ticket.setProject(projectService.findProjectById(1L));
//			ticketService.saveTicket(ticket);
		} else {
			//change to redirect to login
			return new ModelAndView("accessDenied", null);
		}

		return new ModelAndView("ticket/newTicket", myModel);
	}
	
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	public ModelAndView saveTicket(Principal principal, @ModelAttribute("ticket") Ticket ticket, BindingResult result, @RequestParam("project")String project) {
		Map<String, Object> myModel = new HashMap<String, Object>();
		
		if (principal != null) {
			CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
			if (userDetails.getUserRole() != UserRole.ROLE_ADMIN)
				return new ModelAndView("accessDenied", null);

			User u = userService.findUserById(userDetails.getId());
			myModel.put("user", u);
			ticket.setUser(u);
			//TODO un truc propre
			ticket.setProject(projectService.findProjectById(Long.parseLong(project)));
			//ticket.setProject(projectService.findProjectById(1L));
			ticketService.saveTicket(ticket);
		} else {
			//should redirect to login
			return new ModelAndView("accessDenied", null);
		}

		//should redirect
		return new ModelAndView("redirect:" + "/ticket/new");
	}
}