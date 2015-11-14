package fr.projecthandler.model;

import java.util.Date;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.Table;

import fr.projecthandler.util.Utilities;

//import com.fasterxml.jackson.annotation.JsonIgnore;

@Entity
@Table(name = "event")
public class Event extends BaseEntity implements java.io.Serializable {

	private static final long serialVersionUID = -7529770451548409449L;

	@Column(name = "title", length = 30)
	private String title;

	@Column(name = "description", length = 500)
	private String description;

	@Column(name = "starting_date")
	private Date startingDate;

	@Column(name = "ending_date")
	private Date endingDate;

	@Column(name = "status", length = 30)
	private String status;

	// @JsonIgnore
	@ManyToMany(fetch = FetchType.LAZY)
	@JoinTable(name = "users_events", joinColumns = { @JoinColumn(name = "events_id", referencedColumnName = "id") }, inverseJoinColumns = { @JoinColumn(name = "users_id", referencedColumnName = "id") })
	private List<User> users;

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = Utilities.truncate(title, 30);
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = Utilities.truncate(description, 500);
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
		this.status = Utilities.truncate(status, 30);
	}

	public List<User> getUsers() {
		return users;
	}

	public void setUsers(List<User> users) {
		this.users = users;
	}
}
