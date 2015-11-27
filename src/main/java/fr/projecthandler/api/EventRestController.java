package fr.projecthandler.api;

import fr.projecthandler.annotation.CurrentUserDetails;
import fr.projecthandler.api.dto.ApiEventDTO;
import fr.projecthandler.api.exception.ApiNotFoundException;
import fr.projecthandler.model.Event;
import fr.projecthandler.service.EventService;
import fr.projecthandler.service.TokenService;
import fr.projecthandler.session.CustomUserDetails;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import springfox.documentation.annotations.ApiIgnore;

@RestController
@Transactional
@Api(value="Event", description="Operations about events")
@RequestMapping(value = "/api/event", produces = MediaType.APPLICATION_JSON_VALUE + ";charset=UTF-8")
public class EventRestController {

	private static final Logger log = LoggerFactory.getLogger(EventRestController.class);

	@Autowired
	EventService eventService;

	@Autowired
	TokenService tokenService;

	//TODO return
	@RequestMapping(value = "/get/{id}", method = RequestMethod.GET)
	@ApiOperation(value = "Gets event by id", response=ApiEventDTO.class)
	@ApiResponses(value = {
		    @ApiResponse(code = HttpServletResponse.SC_OK, message = "Successful retrieval of event", response = ApiEventDTO.class),
		    @ApiResponse(code = HttpServletResponse.SC_NOT_FOUND, message = "Event with given id does not exist")
		    }
		)
	@ResponseStatus(HttpStatus.OK)
	public ApiEventDTO get(@PathVariable Long id, @ApiIgnore @CurrentUserDetails CustomUserDetails userDetails) throws ApiNotFoundException {
		Event event = eventService.findEventById(id);

		if (event == null) {
			throw new ApiNotFoundException(id);
		}
		ApiEventDTO eventDTO = new ApiEventDTO(event);

		return eventDTO;
	}

	@RequestMapping(value = "/getEventsByUser/{id}", method = RequestMethod.GET)
	@ApiOperation(value = "Gets event by user id", response=ApiEventDTO.class)
	@ApiResponses(value = {
		    @ApiResponse(code = HttpServletResponse.SC_OK, message = "Successful retrieval of events", response = ApiEventDTO.class),
		    @ApiResponse(code = HttpServletResponse.SC_NOT_FOUND, message = "User with given id does not exist")
		    }
		)
	@ResponseStatus(HttpStatus.OK)
	public List<ApiEventDTO> getEventsByUser(@PathVariable Long id) throws ApiNotFoundException {
		Set<Event> eventList = eventService.getEventsByUser(id);

		// TODO Not found if user id not found. If eventList null, empty.
		if (eventList == null) {
			throw new ApiNotFoundException(id);
		}

		List<ApiEventDTO> eventListDTO = new ArrayList<ApiEventDTO>();

		for (Event event : eventList) {
			ApiEventDTO eventDTO = new ApiEventDTO(event);
			eventListDTO.add(eventDTO);
		}

		return eventListDTO;
	}

	// TODO getEventsByUserAndDate
	// TODO getEventsByCurrentUser
}
