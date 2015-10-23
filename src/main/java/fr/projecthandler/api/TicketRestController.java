package fr.projecthandler.api;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

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
import fr.projecthandler.dto.MobileSubTaskDTO;
import fr.projecthandler.dto.MobileTicketDTO;
import fr.projecthandler.model.Ticket;
import fr.projecthandler.model.TicketMessage;
import fr.projecthandler.service.TicketService;
import fr.projecthandler.service.TokenService;
import fr.projecthandler.service.UserService;
import fr.projecthandler.session.CustomUserDetails;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;
import springfox.documentation.annotations.ApiIgnore;

@RestController
@Transactional
@Api(value="Ticket", description="Operations about tickets")
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

	@RequestMapping(value = {"/allByUser", "/allByCurrentUser"}, method = RequestMethod.GET)
	@ApiOperation(value = "Gets all tickets by the authenticated user", response = MobileTicketDTO.class)
	@ApiResponses(value = {
		    @ApiResponse(code = HttpServletResponse.SC_OK, message = "Successful operation"),
		    @ApiResponse(code = HttpServletResponse.SC_BAD_REQUEST, message = "Incorrect subtask entity syntax")
		    }
		)
	public @ResponseBody ResponseEntity<String> getTicketsByCurrentUser(
			@ApiIgnore @CurrentUserDetails CustomUserDetails userDetails) {
		try {
			List<Ticket> ticketList = ticketService.getTicketsByUser(userDetails.getId());
			//TODO remove not found, just empty
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
			e.printStackTrace();
			return new ResponseEntity<String>("KO", HttpStatus.BAD_REQUEST);
		}
	}
}
