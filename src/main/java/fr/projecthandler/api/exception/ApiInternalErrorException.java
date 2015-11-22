package fr.projecthandler.api.exception;

public class ApiInternalErrorException extends Exception {

	private static final long serialVersionUID = -554755213419348854L;

	public ApiInternalErrorException() {
		super("Unexpected error");
	}

	public ApiInternalErrorException(String message) {
		super(message);
	}
}
