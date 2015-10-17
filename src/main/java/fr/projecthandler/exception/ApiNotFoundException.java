package fr.projecthandler.exception;

import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.ResponseStatus;

@ResponseStatus(value = HttpStatus.NOT_FOUND, reason = "Not Found")
public class ApiNotFoundException extends Exception {

	private static final long serialVersionUID = -4325628711733796282L;

	public ApiNotFoundException(Long id){
	        super("NotFoundException with id =" + id);
	    }
}
