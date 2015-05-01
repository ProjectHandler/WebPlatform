package fr.projecthandler.dto;

import java.util.Date;

import fr.projecthandler.model.Event;
import fr.projecthandler.model.Task;

public class  CalendarDTO {

	private Long id;
	private String title;
	private String description;
	private Date start;
	private Date end;
	private Boolean allDay;
		
	public CalendarDTO(Task task) {
		this.id = task.getId();
		this.title = task.getName();
		this.description = task.getDescription();
		this.start = task.getStartingDate();
		this.end = task.getEndingDate();
		this.allDay = false;
	}
	
	public CalendarDTO(Event event) {
		this.id = event.getId();
		this.title = event.getTitle();
		this.description = event.getDescription();
		this.start = event.getStartingDate();
		this.end = event.getEndingDate();
		this.allDay = false;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
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

	public void setDescription(String text) {
		this.description = text;
	}

	public Date getStart() {
		return start;
	}

	public void setStart(Date start) {
		this.start = start;
	}

	public Date getEnd() {
		return end;
	}

	public void setEnd(Date end) {
		this.end = end;
	}
	
	public Boolean getAllDay() {
		return allDay;
	}

	public void setAllDay(Boolean allDay) {
		this.allDay = allDay;
	}

	@Override
	public String toString() {
		return "Calendar [title=" + title + ", description=" + description + ", start=" + start + ", end=" + end + ", allDay=" + allDay + "]";
	}
	
}