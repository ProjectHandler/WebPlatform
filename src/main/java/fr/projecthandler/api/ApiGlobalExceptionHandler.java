package fr.projecthandler.api;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.ResourceAccessException;

import com.google.common.base.Throwables;

import fr.projecthandler.api.exception.ApiAccessDeniedException;
import fr.projecthandler.api.exception.ApiAuthenticationException;
import fr.projecthandler.api.exception.ApiBadRequestException;
import fr.projecthandler.api.exception.ApiInternalErrorException;
import fr.projecthandler.api.exception.ApiNotFoundException;
import fr.projecthandler.api.exception.ExceptionJsonInfo;

@ControllerAdvice(annotations = RestController.class)
public class ApiGlobalExceptionHandler {

	private static final Logger log = LoggerFactory.getLogger(ApiGlobalExceptionHandler.class);

	@ExceptionHandler(ApiNotFoundException.class)
	@ResponseStatus(value = HttpStatus.NOT_FOUND)
	public @ResponseBody ExceptionJsonInfo handleApiNotFoundException(HttpServletRequest request, Exception exception) {
		HttpStatus status = HttpStatus.NOT_FOUND;

		ExceptionJsonInfo response = new ExceptionJsonInfo();
		response.setUrl(request.getRequestURL().toString());
		response.setMessage(exception.getMessage());
		response.setStatus(status.value());

		return response;
	}

	@ExceptionHandler(ResourceAccessException.class)
	@ResponseStatus(value = HttpStatus.NOT_FOUND)
	public @ResponseBody ExceptionJsonInfo handleNotFoundException(HttpServletRequest request, Exception exception) {
		HttpStatus status = HttpStatus.NOT_FOUND;

		ExceptionJsonInfo response = new ExceptionJsonInfo();
		response.setUrl(request.getRequestURL().toString());
		response.setMessage(exception.getMessage());
		response.setStatus(status.value());

		return response;
	}

	@ExceptionHandler(ApiAuthenticationException.class)
	@ResponseStatus(value = HttpStatus.UNAUTHORIZED)
	public @ResponseBody ExceptionJsonInfo handleApiAuthenticationException(HttpServletRequest request, Exception exception) {
		HttpStatus status = HttpStatus.UNAUTHORIZED;

		ExceptionJsonInfo response = new ExceptionJsonInfo();
		response.setUrl(request.getRequestURL().toString());
		response.setMessage(exception.getMessage());
		response.setStatus(status.value());

		return response;
	}

	@ExceptionHandler(ApiInternalErrorException.class)
	@ResponseStatus(value = HttpStatus.INTERNAL_SERVER_ERROR)
	public @ResponseBody ExceptionJsonInfo handleApiInternalErrorException(HttpServletRequest request, Exception exception) {
		HttpStatus status = HttpStatus.INTERNAL_SERVER_ERROR;

		ExceptionJsonInfo response = new ExceptionJsonInfo();
		response.setUrl(request.getRequestURL().toString());
		response.setMessage(exception.getMessage());
		response.setStatus(status.value());

		return response;
	}

	@ExceptionHandler(Exception.class)
	@ResponseStatus(value = HttpStatus.INTERNAL_SERVER_ERROR)
	public @ResponseBody ExceptionJsonInfo handleException(HttpServletRequest request, Exception exception) {
		HttpStatus status = HttpStatus.INTERNAL_SERVER_ERROR;

		log.error("api internal server error\n" + Throwables.getRootCause(exception).getMessage() + "\n", exception);
		ExceptionJsonInfo response = new ExceptionJsonInfo();
		response.setUrl(request.getRequestURL().toString());
		response.setMessage(exception.getMessage());
		response.setStatus(status.value());

		return response;
	}

	@ExceptionHandler(ApiAccessDeniedException.class)
	@ResponseStatus(value = HttpStatus.FORBIDDEN)
	public @ResponseBody ExceptionJsonInfo handleApiAccessDeniedException(HttpServletRequest request, Exception exception) {
		HttpStatus status = HttpStatus.FORBIDDEN;

		ExceptionJsonInfo response = new ExceptionJsonInfo();
		response.setUrl(request.getRequestURL().toString());
		response.setMessage(exception.getMessage());
		response.setStatus(status.value());

		return response;
	}

	@ExceptionHandler(AccessDeniedException.class)
	@ResponseStatus(value = HttpStatus.FORBIDDEN)
	public @ResponseBody ExceptionJsonInfo handleAccessDeniedException(HttpServletRequest request, Exception exception) {
		HttpStatus status = HttpStatus.FORBIDDEN;

		ExceptionJsonInfo response = new ExceptionJsonInfo();
		response.setUrl(request.getRequestURL().toString());
		response.setMessage(exception.getMessage());
		response.setStatus(status.value());

		return response;
	}

	@ExceptionHandler(MissingServletRequestParameterException.class)
	@ResponseStatus(value = HttpStatus.BAD_REQUEST)
	public @ResponseBody ExceptionJsonInfo missingParamterHandler(HttpServletRequest request, Exception exception) {
		String message;

		if (StringUtils.isEmpty(exception.getMessage()))
			message = "A required parameter is missing";
		else
			message = exception.getMessage();

		HttpStatus status = HttpStatus.BAD_REQUEST;

		ExceptionJsonInfo response = new ExceptionJsonInfo();
		response.setUrl(request.getRequestURL().toString());
		response.setMessage(message);
		response.setStatus(status.value());

		return response;
	}

	@ExceptionHandler(ApiBadRequestException.class)
	@ResponseStatus(value = HttpStatus.BAD_REQUEST)
	public @ResponseBody ExceptionJsonInfo handleApiBadRequestException(HttpServletRequest request, Exception exception) {
		HttpStatus status = HttpStatus.BAD_REQUEST;

		ExceptionJsonInfo response = new ExceptionJsonInfo();
		response.setUrl(request.getRequestURL().toString());
		response.setMessage(exception.getMessage());
		response.setStatus(status.value());

		return response;
	}

}
