package fr.projecthandler.model;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

@Entity
@Table(name = "calendar")
public class  Calendar extends BaseEntity implements java.io.Serializable {

	private static final long serialVersionUID = 4903546468464810423L;
	
	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "user_id")
	private User user;
	
	@Column(name = "title")
	private String title;
	
	@Column(name = "text")
	private String text;
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "start_date", length = 10)
	private Date start;
	
	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "end_date", length = 10)
	private Date end;

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
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
		return "Calendar [userId=" + user + ", title=" + title + ", text=" + text + ", start=" + start + ", end=" + end + "]";
	}
	
}