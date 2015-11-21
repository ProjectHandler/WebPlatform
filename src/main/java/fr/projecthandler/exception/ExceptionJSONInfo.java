package fr.projecthandler.exception;

import java.io.Serializable;

public class ExceptionJSONInfo implements Serializable {

	private static final long serialVersionUID = 5776190087431557189L;

	private int status;
	private String url;
	private String message;

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}
}
