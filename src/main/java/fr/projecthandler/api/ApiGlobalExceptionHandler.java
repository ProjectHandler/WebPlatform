package fr.projecthandler.api;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import fr.projecthandler.exception.ApiNotFoundException;
import fr.projecthandler.exception.ExceptionJSONInfo;

@ControllerAdvice(annotations = RestController.class)
public class ApiGlobalExceptionHandler {
	
	private static final Logger log = LoggerFactory.getLogger(ApiGlobalExceptionHandler.class);

	@ExceptionHandler(ApiNotFoundException.class)
	public @ResponseBody ResponseEntity<String> handleNotFoundException(HttpServletRequest request,
			Exception exception) {
	    String json = "";
	    HttpStatus status = HttpStatus.NOT_FOUND;
	    
		ExceptionJSONInfo response = new ExceptionJSONInfo();
		response.setUrl(request.getRequestURL().toString());
		response.setMessage(exception.getMessage());
		response.setStatus(status.value());
		Gson gson = new GsonBuilder().disableHtmlEscaping().create();
		try {
			json = gson.toJson(response);
		} catch (Exception e) {
			log.error("error in handleNotFoundException", e);
		}

		return new ResponseEntity<String>(json, status);
	}
	
	@ExceptionHandler(MissingServletRequestParameterException.class)
	public @ResponseBody ResponseEntity<String> missingParamterHandler(HttpServletRequest request, Exception exception) {
		    String json = "";
		    String message;
		    if (StringUtils.isEmpty(exception.getMessage())) 
		    	message = "A required parameter is missing.";
		    else 
		    	message = exception.getMessage();
		    
		    HttpStatus status = HttpStatus.BAD_REQUEST;
		    
			ExceptionJSONInfo response = new ExceptionJSONInfo();
			response.setUrl(request.getRequestURL().toString());
			response.setMessage(message);
			response.setStatus(status.value());
			Gson gson = new GsonBuilder().disableHtmlEscaping().create();
			try {
				json = gson.toJson(response);
			} catch (Exception e) {
				log.error("error in missingParamterHandler", e);
			}

			return new ResponseEntity<String>(json, status);
	}
}
