package fr.projecthandler.dto;

import java.util.Date;

import fr.projecthandler.model.Event;
import fr.projecthandler.model.SubTask;
import fr.projecthandler.model.Task;

public class  CalendarDTO {

	private Long id;
	private String title;
	private String description;
	private String type;
	private Date start;
	private Date end;
	private Boolean editable;
	private Boolean allDay;
		
	public CalendarDTO(Task task) {
		this.id = task.getId();
		this.title = task.getName();
		this.description = task.getDescription();
		this.type = "task";
		this.start = task.getStartingDate();
		this.end = task.getEndingDate();
		this.editable = false;
		this.allDay = true;
	}
	
	public CalendarDTO(Event event) {
		Long moreThanOneDay	= 5184000l;	// 1 jours ms
		this.id = event.getId();
		this.title = event.getTitle();
		this.description = event.getDescription();
		this.type = "event";
		this.start = event.getStartingDate();
		this.end = event.getEndingDate();
		this.editable = true;
		if (event.getStartingDate().getTime() - event.getEndingDate().getTime() > moreThanOneDay)
			this.allDay = true;
		else
			this.allDay = false;
	}

	public CalendarDTO(SubTask subTask) {
		this.id = subTask.getId();
		this.title = " ";
		this.description = subTask.getDescription();
		this.type = "subtask";
		this.start = subTask.getStartingDate();
		this.end = subTask.getEndingDate();
		this.editable = true;
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
	
	public Boolean getEditable() {
		return editable;
	}

	public void setEditable(Boolean editable) {
		this.editable = editable;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public Boolean getAllDay() {
		return allDay;
	}

	public void setAllDay(Boolean allDay) {
		this.allDay = allDay;
	}

	@Override
	public String toString() {
		return "Calendar [title=" + title + ", description=" + description + ", start=" + start + ", end=" + end + ", editable=" + editable  + ", allDay=" + allDay + "]";
	}
	
}