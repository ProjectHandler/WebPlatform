package fr.projecthandler.api;
/*
import java.io.IOException;
import java.io.StringWriter;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.fasterxml.jackson.core.JsonGenerationException;
import com.fasterxml.jackson.databind.JsonMappingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;

import fr.projecthandler.model.Ticket;
import fr.projecthandler.model.TicketMessage;
import fr.projecthandler.service.TicketService;
import fr.projecthandler.service.TokenService;
import fr.projecthandler.service.UserService;

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
	private UserDetailsService customUserDetailsService;

	@RequestMapping(value = "/get/{id}", method = RequestMethod.GET)
	public @ResponseBody ResponseEntity<String> get(@PathVariable Long id) {
		Ticket ticket = ticketService.findTicketById(id);

		if (ticket == null) {
			return new ResponseEntity<String>(
					"{\"status\":400, \"ticket\":\"Not found\"}",
					HttpStatus.NOT_FOUND);
		}

		ObjectMapper objectMapper = new ObjectMapper();
		objectMapper.configure(SerializationFeature.INDENT_OUTPUT, true);
		StringWriter stringEmp = new StringWriter();
		try {
			objectMapper.writeValue(stringEmp, ticket);
		} catch (JsonGenerationException e) {
			e.printStackTrace();
		} catch (JsonMappingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

		return new ResponseEntity<String>(stringEmp.toString(), HttpStatus.OK);
	}

	@RequestMapping(value = "/findTicketMessageById/{id}", method = RequestMethod.GET)
	public @ResponseBody ResponseEntity<String> findTicketMessageById(
			@PathVariable Long id) {
		TicketMessage ticketMessage = ticketService.findTicketMessageById(id);

		if (ticketMessage == null) {
			return new ResponseEntity<String>(
					"{\"status\":400, \"ticket message\":\"Not found\"}",
					HttpStatus.NOT_FOUND);
		}

		ObjectMapper objectMapper = new ObjectMapper();
		objectMapper.configure(SerializationFeature.INDENT_OUTPUT, true);
		StringWriter stringEmp = new StringWriter();
		try {
			objectMapper.writeValue(stringEmp, ticketMessage);
		} catch (JsonGenerationException e) {
			e.printStackTrace();
		} catch (JsonMappingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

		return new ResponseEntity<String>(stringEmp.toString(), HttpStatus.OK);
	}

}*/
