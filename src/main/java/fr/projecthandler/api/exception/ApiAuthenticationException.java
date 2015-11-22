package fr.projecthandler.api.exception;

public class ApiAuthenticationException extends Exception {

	private static final long serialVersionUID = -4325628711733796282L;

	public ApiAuthenticationException() {
		super();
	}

	public ApiAuthenticationException(String message) {
		super(message);
	}
}
