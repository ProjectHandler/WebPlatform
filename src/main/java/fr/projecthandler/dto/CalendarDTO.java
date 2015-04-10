package fr.projecthandler.dto;

import java.util.Date;

import fr.projecthandler.model.Task;

public class  CalendarDTO {

	private Long id;
	private String title;
	private String description;
	private Date start;
	private Date end;
		
	public CalendarDTO(Task task) {
		this.id = task.getId();
		this.title = task.getName();
		this.description = task.getDescription();
		this.start = task.getStartingDate();
		this.end = task.getEndingDate();
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

	@Override
	public String toString() {
		return "Calendar [title=" + title + ", description=" + description + ", start=" + start + ", end=" + end + "]";
	}
	
}