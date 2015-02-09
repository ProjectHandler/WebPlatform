package fr.projecthandler.dto;

import java.util.Date;
import fr.projecthandler.model.Calendar;

public class  CalendarDTO {

	private Long id;
	private Long userId;
	private String title;
	private String text;
	private Date start;
	private Date end;
		
	public CalendarDTO(Calendar calendar) {
		this.id = calendar.getId();
		this.userId = calendar.getUser().getId();
		this.title = calendar.getTitle();
		this.text = calendar.getText();
		this.start = calendar.getStart();
		this.end = calendar.getEnd();
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getUserId() {
		return userId;
	}

	public void setUserId(Long userId) {
		this.userId = userId;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
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
		return "Calendar [userId=" + userId + ", title=" + title + ", text=" + text + ", start=" + start + ", end=" + end + "]";
	}
	
}