package fr.projecthandler.web;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;
import javax.validation.Valid;

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

import fr.projecthandler.annotation.CurrentUserDetails;
import fr.projecthandler.enums.TicketStatus;
import fr.projecthandler.enums.UserRole;
import fr.projecthandler.model.Project;
import fr.projecthandler.model.Ticket;
import fr.projecthandler.model.TicketMessage;
import fr.projecthandler.model.TicketPriority;
import fr.projecthandler.model.TicketTracker;
import fr.projecthandler.model.User;
import fr.projecthandler.service.ProjectService;
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
	ProjectService projectService;

	@RequestMapping(value = "/new/{projectId}", method = RequestMethod.GET)
	public ModelAndView addTicket(@CurrentUserDetails CustomUserDetails userDetails, @PathVariable Long projectId,
			@RequestParam(required = false) String title) {
		Map<String, Object> model = new HashMap<String, Object>();

		if (userDetails == null) {
			return new ModelAndView("redirect:/");
		}
		Project project = projectService.findProjectById(projectId);
		if (project == null) {
			// TODO not found
			return new ModelAndView("redirect:/");
		}
		// TODO vérifier droit du user
		Ticket ticket = new Ticket();
		ticket.setTitle(title);
		User u = userService.findUserById(userDetails.getId());
		List<Project> projectList = projectService.getAllProjects();
		List<TicketTracker> ticketTrackerList = ticketService.getAllTicketTrackers();
		List<TicketPriority> ticketPriorityList = ticketService.getAllTicketPriorities();

		ticket.setProject(project);
		model.put("user", u);
		model.put("ticket", ticket);
		model.put("projectList", projectList);
		model.put("ticketTrackerList", ticketTrackerList);
		model.put("ticketPriorityList", ticketPriorityList);

		return new ModelAndView("ticket/addTicket", model);
	}

	@RequestMapping(value = "/save", method = RequestMethod.POST)
	public ModelAndView saveTicket(@CurrentUserDetails CustomUserDetails userDetails, @ModelAttribute("ticket") @Valid Ticket ticket,
			BindingResult result) {
		if (userDetails == null) {
			// TODO redirect to login
			return new ModelAndView("accessDenied");
		}
		if (result.hasErrors()) {
			// TODO redirect
			return new ModelAndView("redirect:/");
		}
		// TODO check des permissions, check si les ID sont valides
		User user = userService.findUserById(userDetails.getId());
		ticket.setUser(user);
		ticketService.saveTicket(ticket);
		return new ModelAndView("redirect:" + "/ticket/" + ticket.getId() + "/messages");
	}

	@RequestMapping(value = "/{ticketId}/messages", method = RequestMethod.GET)
	public ModelAndView saveTicket(@CurrentUserDetails CustomUserDetails userDetails, @PathVariable Long ticketId) {
		Map<String, Object> myModel = new HashMap<String, Object>();
		Ticket ticket = ticketService.findTicketById(ticketId);

		if (userDetails == null) {
			// TODO redirect to login
			return new ModelAndView("accessDenied");
		}
		if (ticket == null) {
			// TODO mettre un Not Found, c'est pas un accessDenied
			return new ModelAndView("accessDenied");
		}
		// TODO check si le user est dans le projet

		User u = userService.findUserById(userDetails.getId());
		TicketMessage ticketMessage = new TicketMessage();
		List<TicketMessage> ticketMessages = ticketService.getTicketMessagesByTicketId(ticketId);

		myModel.put("user", u);
		myModel.put("ticket", ticket);
		myModel.put("ticketMessage", ticketMessage);
		myModel.put("ticketMessages", ticketMessages);

		return new ModelAndView("ticket/ticketMessages", myModel);
	}

	@RequestMapping(value = "/{ticketId}/message/save", method = RequestMethod.POST)
	public ModelAndView saveTicket(@CurrentUserDetails CustomUserDetails userDetails,
			@Valid @ModelAttribute("ticketMessage") TicketMessage ticketMessage, BindingResult result, @PathVariable Long ticketId) {
		Ticket ticket = ticketService.findTicketById(ticketId);

		// TODO ajouter les autres tests pour confirmer que ce User peut écrire
		// sur ce ticket
		if (userDetails == null) {
			// TODO redirect to login
			return new ModelAndView("accessDenied");
		}
		if (ticket == null || ticket.getTicketStatus() == TicketStatus.CLOSED) {
			// TODO mettre un Not Found, c'est pas un accessDenied
			return new ModelAndView("accessDenied");
		}
		if (result.hasErrors()) {
			return new ModelAndView("redirect:/ticket/" + ticketId + "/messages");
		}
		User u = userService.findUserById(userDetails.getId());

		ticketMessage.setUser(u);
		ticketMessage.setTicket(ticket);
		ticketService.saveTicketMessage(ticketMessage);

		return new ModelAndView("redirect:" + "/ticket/" + ticket.getId() + "/messages");
	}

	@RequestMapping(value = "/list/project/{projectId}", method = RequestMethod.GET)
	public ModelAndView ticketList(Principal principal, @PathVariable Long projectId) {
		Map<String, Object> model = new HashMap<String, Object>();

		// TODO les checks
		if (principal != null) {
			CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
			User u = userService.findUserById(userDetails.getId());

			model.put("user", u);
			List<Ticket> ticketList = ticketService.getTicketsByProjectId(projectId);
			model.put("ticketList", ticketList);
			model.put("projectId", projectId);
		} else {
			// TODO redirect to login
			return new ModelAndView("accessDenied");
		}

		return new ModelAndView("ticket/ticketList", model);
	}

	//TODO check what happens if invalid ticket id
	@RequestMapping(value = "/delete", method = RequestMethod.POST)
	public ModelAndView deleteTicket(@CurrentUserDetails CustomUserDetails userDetails,
			@RequestParam Long ticketId) {
		User u = userService.findUserById(userDetails.getId());
		Ticket ticket = ticketService.findTicketById(ticketId);
		
		if (userDetails == null
				|| ticket == null
				|| (userDetails.getUserRole() != UserRole.ROLE_ADMIN && userDetails.getId() != ticket.getUser().getId())) {
			return new ModelAndView("accessDenied");
		}

		Long projectId = ticket.getProject().getId();
		try {
			ticketService.deleteTicketById(ticket.getId());
		} catch (Exception e) {
			e.printStackTrace();
		}

		return new ModelAndView("redirect:/ticket/list/project/" + projectId);
	}
}