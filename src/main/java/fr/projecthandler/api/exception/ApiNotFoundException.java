package fr.projecthandler.api.exception;

public class ApiNotFoundException extends Exception {

	private static final long serialVersionUID = -4325628711733796282L;

	public ApiNotFoundException(Long id){
	        super("NotFoundException with id =" + id);
	    }
}
