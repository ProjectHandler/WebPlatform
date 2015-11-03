package fr.projecthandler.api;

import fr.projecthandler.annotation.CurrentUserDetails;
import fr.projecthandler.dto.MobileProjectDTO;
import fr.projecthandler.dto.MobileTicketDTO;
import fr.projecthandler.dto.MobileTicketMessageDTO;
import fr.projecthandler.dto.MobileUserDTO;
import fr.projecthandler.model.Project;
import fr.projecthandler.model.Ticket;
import fr.projecthandler.model.TicketMessage;
import fr.projecthandler.model.User;
import fr.projecthandler.service.ProjectService;
import fr.projecthandler.service.TicketService;
import fr.projecthandler.service.TokenService;
import fr.projecthandler.service.UserService;
import fr.projecthandler.session.CustomUserDetails;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import springfox.documentation.annotations.ApiIgnore;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

@RestController
@Transactional
@Api(value = "Ticket", description = "Operations about tickets")
@RequestMapping("/api/ticket")
public class TicketRestController {

	private static final Logger log = LoggerFactory.getLogger(TicketRestController.class);

	@Autowired
	UserService userService;

	@Autowired
	TokenService tokenService;

	@Autowired
	TicketService ticketService;

	@Autowired
	ProjectService projectService;
	
	@Autowired
	UserDetailsService customUserDetailsService;

	@RequestMapping(value = { "/allByCurrentUser" }, method = RequestMethod.GET)
	@ApiOperation(value = "Gets all tickets by the authenticated user", response = MobileTicketDTO.class)
	@ApiResponses(value = { @ApiResponse(code = HttpServletResponse.SC_OK, message = "Successful operation"),
			@ApiResponse(code = HttpServletResponse.SC_BAD_REQUEST, message = "Incorrect subtask entity syntax") })
	public @ResponseBody ResponseEntity<String> getTicketsByCurrentUser(@ApiIgnore @CurrentUserDetails CustomUserDetails userDetails) {
		try {
			List<Ticket> ticketList = ticketService.getTicketsByUser(userDetails.getId());
			// TODO remove not found, just empty
			if (ticketList == null) {
				return new ResponseEntity<String>("{\"status\":400, \"project\":\"Not found\"}", HttpStatus.NOT_FOUND);
			}
			List<MobileTicketDTO> ticketListDTO = new ArrayList<MobileTicketDTO>();

			for (Ticket ticket : ticketList) {
				MobileTicketDTO mobileTicketDTO = new MobileTicketDTO(ticket);
				List<TicketMessage> listTicketMessage = ticketService.getTicketMessagesByTicketId(ticket.getId());
				mobileTicketDTO.setMessage(listTicketMessage);
				ticketListDTO.add(mobileTicketDTO);
			}

			Gson gson = new GsonBuilder().setExclusionStrategies(new ApiExclusionStrategy()).create();
			String json = gson.toJson(ticketListDTO);

			return new ResponseEntity<String>(json, HttpStatus.OK);
		} catch (Exception e) {
			log.error("error in getTicketsByCurrentUser", e);
			return new ResponseEntity<String>("KO", HttpStatus.BAD_REQUEST);
		}
	}

	@RequestMapping(value = { "/allByProject/{projectId}" }, method = RequestMethod.GET)
	public @ResponseBody ResponseEntity<String> getTicketsByProject(@ApiIgnore @CurrentUserDetails CustomUserDetails userDetails,
			@PathVariable Long projectId) {
		try {
			List<Ticket> ticketList = ticketService.getTicketsByProjectId(projectId);

			List<MobileTicketDTO> ticketListDTO = new ArrayList<MobileTicketDTO>();

			for (Ticket ticket : ticketList) {
				MobileTicketDTO mobileTicketDTO = new MobileTicketDTO(ticket);
				List<TicketMessage> listTicketMessage = ticketService.getTicketMessagesByTicketId(ticket.getId());
				mobileTicketDTO.setMessage(listTicketMessage);
				ticketListDTO.add(mobileTicketDTO);
			}

			Gson gson = new GsonBuilder().setExclusionStrategies(new ApiExclusionStrategy()).create();
			String json = gson.toJson(ticketListDTO);

			return new ResponseEntity<String>(json, HttpStatus.OK);
		} catch (Exception e) {
			log.error("error in getTicketsByCurrentUser", e);
			return new ResponseEntity<String>("KO", HttpStatus.BAD_REQUEST);
		}
	}

	@RequestMapping(value = { "/allByProjectAndUser/{projectId}" }, method = RequestMethod.GET)
	public @ResponseBody ResponseEntity<String> getTicketsByProjectAndUser(@ApiIgnore @CurrentUserDetails CustomUserDetails userDetails,
			@PathVariable Long projectId) {
		try {
			List<Ticket> ticketList = ticketService.getTicketsByProjectIdAndUser(projectId, userDetails.getId());

			List<MobileTicketDTO> ticketListDTO = new ArrayList<MobileTicketDTO>();

			for (Ticket ticket : ticketList) {
				MobileTicketDTO mobileTicketDTO = new MobileTicketDTO(ticket);
				List<TicketMessage> listTicketMessage = ticketService.getTicketMessagesByTicketId(ticket.getId());
				mobileTicketDTO.setMessage(listTicketMessage);
				ticketListDTO.add(mobileTicketDTO);
			}

			Gson gson = new GsonBuilder().setExclusionStrategies(new ApiExclusionStrategy()).create();
			String json = gson.toJson(ticketListDTO);

			return new ResponseEntity<String>(json, HttpStatus.OK);
		} catch (Exception e) {
			log.error("error in getTicketsByCurrentUser", e);
			return new ResponseEntity<String>("KO", HttpStatus.BAD_REQUEST);
		}
	}

	@RequestMapping(value = { "/saveNewTicketMessage/{ticketId}" }, method = RequestMethod.POST)
	public @ResponseBody ResponseEntity<String> saveNewTicketMessage(@ApiIgnore @CurrentUserDetails CustomUserDetails userDetails,
			@PathVariable Long ticketId, @RequestBody String jsonObject) {
		try {
			Gson gson = new Gson();
			final MobileTicketMessageDTO ticketMessageDTO = gson.fromJson(jsonObject, MobileTicketMessageDTO.class);
			TicketMessage ticketMessage = new TicketMessage(ticketMessageDTO);
			ticketMessage.setUser(userService.findUserById(userDetails.getId()));
			ticketMessage.setTicket(ticketService.findTicketById(ticketId));
			ticketService.saveTicketMessage(ticketMessage);
			gson = new GsonBuilder().setExclusionStrategies(new ApiExclusionStrategy()).create();
			String json = gson.toJson(new MobileTicketMessageDTO(ticketMessage));

			return new ResponseEntity<String>(json, HttpStatus.OK);
		} catch (Exception e) {
			log.error("error in saveNewTicketMessage", e);
			return new ResponseEntity<String>("KO", HttpStatus.BAD_REQUEST);
		}
	}
	
	@RequestMapping(value = { "/dataForNewTicket" }, method = RequestMethod.GET)
	public @ResponseBody ResponseEntity<String> getDataForNewTicket(@ApiIgnore @CurrentUserDetails CustomUserDetails userDetails) {
		try {
			// In development !
			System.out.println("test 1");
		    /*private Set<User> users;
		    private Set<TicketPriority> ticketPriorities;
		    private Set<TicketTracker> ticketTrackers;*/
			
			Map<String, Object> myModel = new HashMap<String, Object>();
			List<Project> projects = projectService.getProjectsByUserIdAndFetchUsers(userDetails.getId());
			
			List<MobileProjectDTO> projectsDTO = new ArrayList<MobileProjectDTO>();
			for (Project p : projects) {
				MobileProjectDTO pDTO = new MobileProjectDTO(p);
				List<MobileUserDTO> usersDTO = new ArrayList<MobileUserDTO>();
				for (User u : p.getUsers())
					usersDTO.add(new MobileUserDTO(u));
				pDTO.setUsers(usersDTO);
				projectsDTO.add(pDTO);
			}
			
			myModel.put("projects", projectsDTO);
			myModel.put("ticketPriorities", ticketService.getAllTicketPriorities());
			//myModel.put("ticketTrackers", ticketService.getAllTicketTrackers());
			
			Gson gson = new GsonBuilder().setExclusionStrategies(new ApiExclusionStrategy()).create();
			String json = gson.toJson(myModel);

			System.out.println("json: " + json);
			return new ResponseEntity<String>(json, HttpStatus.OK);
		} catch (Exception e) {
			log.error("error in saveNewTicketMessage", e);
			return new ResponseEntity<String>("KO", HttpStatus.BAD_REQUEST);
		}
	}
}
