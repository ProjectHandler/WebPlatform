package fr.projecthandler.api.exception;

public class ApiAccessDeniedException extends Exception {

	private static final long serialVersionUID = -4555372797360134473L;

	public ApiAccessDeniedException() {
		super("Forbidden");
	}

	public ApiAccessDeniedException(String message) {
		super(message);
	}
}
