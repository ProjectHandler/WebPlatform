package fr.projecthandler.api;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import fr.projecthandler.annotation.CurrentUserDetails;
import fr.projecthandler.dto.MobileTicketDTO;
import fr.projecthandler.model.Ticket;
import fr.projecthandler.service.TicketService;
import fr.projecthandler.service.TokenService;
import fr.projecthandler.service.UserService;
import fr.projecthandler.session.CustomUserDetails;

@RestController
@Transactional
@RequestMapping("/api/ticket")
public class TicketRestController {

	@Autowired
	UserService userService;

	@Autowired
	TokenService tokenService;

	@Autowired
	TicketService ticketService;

	@Autowired
	private UserDetailsService customUserDetailsService;
		
	@RequestMapping(value = "/allByUser", method = RequestMethod.GET)
	public @ResponseBody ResponseEntity<String> getProjects(@CurrentUserDetails CustomUserDetails userDetails) {
		try {
			List<Ticket> ticketList = ticketService.getTicketsByUser(userDetails.getId());
			
			if (ticketList == null) {
				return new ResponseEntity<String>(
						"{\"status\":400, \"project\":\"Not found\"}",
						HttpStatus.NOT_FOUND);
			}
	
			List<MobileTicketDTO> ticketListDTO = new ArrayList<MobileTicketDTO>();
			for (Ticket t : ticketList) {
				ticketListDTO.add(new MobileTicketDTO(t));
			}
			
			Gson gson = new GsonBuilder().setExclusionStrategies(new ApiExclusionStrategy()).create();
			String json = gson.toJson(ticketListDTO);
			
			return new ResponseEntity<String>(json, HttpStatus.OK);
		}catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<String>("KO", HttpStatus.BAD_REQUEST);
		}
	}
}
