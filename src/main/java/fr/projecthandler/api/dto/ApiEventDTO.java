package fr.projecthandler.api.dto;

import java.util.Date;

import fr.projecthandler.model.Event;

public class ApiEventDTO {

	private String title;
	private String description;
	private Date startingDate;
	private Date endingDate;
	private String status;

	public ApiEventDTO(Event event) {
		title = event.getTitle();
		description = event.getDescription();
		startingDate = event.getStartingDate();
		endingDate = event.getEndingDate();
		status = event.getStatus();
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public Date getStartingDate() {
		return startingDate;
	}

	public void setStartingDate(Date startingDate) {
		this.startingDate = startingDate;
	}

	public Date getEndingDate() {
		return endingDate;
	}

	public void setEndingDate(Date endingDate) {
		this.endingDate = endingDate;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
}
