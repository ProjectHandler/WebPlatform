package fr.projecthandler.api.exception;

public class ApiBadRequestException extends Exception {

	private static final long serialVersionUID = 2814615693152043175L;

	public ApiBadRequestException() {
		super("Bad Request");
	}

	public ApiBadRequestException(String message) {
		super(message);
	}
}
