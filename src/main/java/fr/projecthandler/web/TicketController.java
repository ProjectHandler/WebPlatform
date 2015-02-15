package fr.projecthandler.web;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import fr.projecthandler.dao.ProjectDao;
import fr.projecthandler.model.Project;
import fr.projecthandler.model.Ticket;
import fr.projecthandler.model.TicketMessage;
import fr.projecthandler.model.User;
import fr.projecthandler.service.TicketService;
import fr.projecthandler.service.UserService;
import fr.projecthandler.session.CustomUserDetails;

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
			User u = userService.findUserById(userDetails.getId());
			List<Project> projectList = projectService.getAllProjects();
			myModel.put("user", u);
			myModel.put("ticket", ticket);
			myModel.put("projectList", projectList);
		} else {
			//TODO redirect to login
			return new ModelAndView("accessDenied", null);
		}

		return new ModelAndView("ticket/newTicket", myModel);
	}
	
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	public ModelAndView saveTicket(Principal principal, @ModelAttribute("ticket") Ticket ticket, BindingResult result, @RequestParam("project")String project) {
		Map<String, Object> myModel = new HashMap<String, Object>();
		
		if (principal != null) {
			CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
			User u = userService.findUserById(userDetails.getId());

			myModel.put("user", u);
			ticket.setUser(u);
			//TODO un truc propre
			ticket.setProject(projectService.findProjectById(Long.parseLong(project)));
			ticketService.saveTicket(ticket);
		} else {
			//TODO redirect to login
			return new ModelAndView("accessDenied", null);
		}

		return new ModelAndView("redirect:" + "/ticket/" + ticket.getId() + "/messages");
	}
	
	@RequestMapping(value = "/{ticketId}/messages", method = RequestMethod.GET)
	public ModelAndView saveTicket(Principal principal, @PathVariable Long ticketId) {
		Map<String, Object> myModel = new HashMap<String, Object>();
		Ticket ticket = ticketService.findTicketById(ticketId);
		
		if (ticket == null) {
			//TODO mettre la bonne erreur, c'est pas un accessDenied
			return new ModelAndView("accessDenied", null);
		}
		
		if (principal != null) {
			CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
			User u = userService.findUserById(userDetails.getId());
			TicketMessage ticketMessage = new TicketMessage();

			myModel.put("user", u);
			List<TicketMessage> ticketMessages = ticketService.getTicketMessagesByTicketId(ticketId);
			myModel.put("ticket", ticket);
			myModel.put("ticketMessage", ticketMessage);
			myModel.put("ticketMessages", ticketMessages);
		} else {
			//TODO redirect to login
			return new ModelAndView("accessDenied", null);
		}

		return new ModelAndView("ticket/ticketMessages", myModel);
	}
	
	@RequestMapping(value = "/{ticketId}/message/save", method = RequestMethod.POST)
	public ModelAndView saveTicket(Principal principal, @ModelAttribute("ticketMessage") TicketMessage ticketMessage, BindingResult result,	@PathVariable Long ticketId) {
		Map<String, Object> myModel = new HashMap<String, Object>();
		Ticket ticket = ticketService.findTicketById(ticketId);
		
		//TODO ajouter les autres tests pour confirmer que ce User peut écrire sur ce ticket
		if (ticket == null) {
			//TODO mettre un Not Found, c'est pas un accessDenied
			return new ModelAndView("accessDenied", null);
		}
		if (principal != null) {
			CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
			User u = userService.findUserById(userDetails.getId());

			myModel.put("user", u);
			ticketMessage.setUser(u);
			ticketMessage.setTicket(ticket);
			ticketService.saveTicketMessage(ticketMessage);
		} else {
			//TODO redirect to login
			return new ModelAndView("accessDenied", null);
		}

		return new ModelAndView("redirect:" + "/ticket/" + ticket.getId() + "/messages");
	}
	
	
	@RequestMapping(value = "/list/project/{projectId}", method = RequestMethod.GET)
	public ModelAndView ticketList(Principal principal, @PathVariable Long projectId) {
		Map<String, Object> myModel = new HashMap<String, Object>();
		
		if (principal != null) {
			CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
			User u = userService.findUserById(userDetails.getId());

			myModel.put("user", u);
			List<Ticket> ticketList = ticketService.getTicketsByProjectId(projectId);
			myModel.put("ticketList", ticketList);
		} else {
			//TODO redirect to login
			return new ModelAndView("accessDenied", null);
		}

		return new ModelAndView("ticket/ticketList", myModel);
	}
}