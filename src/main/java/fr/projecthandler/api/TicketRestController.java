package fr.projecthandler.api;

import java.security.Principal;
import java.util.ArrayList;
import java.util.List;

import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

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
	@Qualifier("userDatabase")
	private AuthenticationManager authManager;
	
	@Autowired
	private UserDetailsService	customUserDetailsService;
	
	@RequestMapping(value = "/get/{id}", method = RequestMethod.GET)
	public @ResponseBody ResponseEntity<String> get(@PathVariable Long id) {
		Ticket ticket = ticketService.findTicketById(id);
		
		if (ticket == null) {
			return new ResponseEntity<String>("{\"status\":400, \"message\":\"Not found\"}", HttpStatus.NOT_FOUND);
		}
		
		Gson gson = new GsonBuilder().setExclusionStrategies(new ApiExclusionStrategy()).create();
		try {
			String json = gson.toJson(ticket);

			return new ResponseEntity<String>(json, HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<String>("KO", HttpStatus.BAD_REQUEST);
		}
	}

}
