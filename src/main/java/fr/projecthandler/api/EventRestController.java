package fr.projecthandler.api;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import fr.projecthandler.api.dto.ApiEventDTO;
import fr.projecthandler.exception.ApiNotFoundException;
import fr.projecthandler.model.Event;
import fr.projecthandler.service.EventService;
import fr.projecthandler.service.TokenService;
import fr.projecthandler.service.UserService;
import fr.projecthandler.session.CustomUserDetails;

@RestController
@Transactional
@RequestMapping("/api/event")
public class EventRestController {

	@Autowired
	EventService eventService;

	@Autowired
	TokenService tokenService;

	@RequestMapping(value = "/get/{id}", method = RequestMethod.GET)
	public @ResponseBody ResponseEntity<String> get(@PathVariable Long id) throws ApiNotFoundException {
		Event event = eventService.findEventById(id);

		if (event == null) {
			throw new ApiNotFoundException(id);
			// return new ResponseEntity<String>("{\"status\":400,
			// \"event\":\"Not found\"}", HttpStatus.NOT_FOUND);
		}

		ApiEventDTO eventDTO = new ApiEventDTO(event);
		Gson gson = new GsonBuilder().setExclusionStrategies(new ApiExclusionStrategy()).create();
		try {
			String json = gson.toJson(eventDTO);

			return new ResponseEntity<String>(json, HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<String>("KO", HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

	@RequestMapping(value = "/getEventsByUser/{id}", method = RequestMethod.GET)
	public @ResponseBody ResponseEntity<String> getEventsByUser(@PathVariable Long id) {
		Set<Event> eventList = eventService.getEventsByUser(id);

		// TODO Not found if user id not found. If eventList null, empty.
		if (eventList == null) {
			return new ResponseEntity<String>("{\"status\":400, \"events\":\"Not found\"}", HttpStatus.NOT_FOUND);
		}

		List<ApiEventDTO> eventListDTO = new ArrayList<ApiEventDTO>();

		for (Event event : eventList) {
			ApiEventDTO eventDTO = new ApiEventDTO(event);
			eventListDTO.add(eventDTO);
		}

		Gson gson = new GsonBuilder().setExclusionStrategies(new ApiExclusionStrategy()).create();
		try {
			String json = gson.toJson(eventListDTO);

			return new ResponseEntity<String>(json, HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();

			return new ResponseEntity<String>("KO", HttpStatus.BAD_REQUEST);
		}
	}

	//TODO
	// public Set<Event> getYesterdayEventsByUser(Long userId);
	//
	// public Set<Event> getTodayEventsByUser(Long userId);
	//
	// public Set<Event> getTomorrowEventsByUser(Long userId);
}
