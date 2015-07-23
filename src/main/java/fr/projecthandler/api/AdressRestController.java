package fr.projecthandler.api;
/*
import java.io.IOException;
import java.io.StringWriter;
import java.util.List;

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

import com.fasterxml.jackson.core.JsonGenerationException;
//import com.fasterxml.jackson.databind.JsonMappingException;
//import com.fasterxml.jackson.databind.ObjectMapper;
//import com.fasterxml.jackson.databind.SerializationFeature;

import fr.projecthandler.annotation.CurrentUserDetails;
import fr.projecthandler.enums.AccountStatus;
import fr.projecthandler.enums.UserRole;
import fr.projecthandler.model.Address;
import fr.projecthandler.service.AddressService;
import fr.projecthandler.service.TokenService;
import fr.projecthandler.session.CustomUserDetails;

@RestController
@Transactional
@RequestMapping("/api/address")
public class AdressRestController {

	@Autowired
	AddressService addressService;

	@Autowired
	TokenService tokenService;

	@RequestMapping(value = "/getAddressByUser/{id}", method = RequestMethod.GET)
	public @ResponseBody ResponseEntity<String> get(@PathVariable Long id) {
		List<Address> addresses = addressService.getAddressesByUser(id);

		if (addresses.isEmpty()) {
			return new ResponseEntity<String>(
					"{\"status\":400, \"address\":\"Not found\"}",
					HttpStatus.NOT_FOUND);
		}

		// create ObjectMapper instance
		ObjectMapper objectMapper = new ObjectMapper();

		// configure Object mapper for pretty print
		objectMapper.configure(SerializationFeature.INDENT_OUTPUT, true);

		// writing to console, can write to any output stream such as file
		StringWriter stringEmp = new StringWriter();
		try {
			objectMapper.writeValue(stringEmp, addresses.get(0));
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
