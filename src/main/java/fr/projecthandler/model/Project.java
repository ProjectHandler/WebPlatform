package fr.projecthandler.model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import org.springframework.format.annotation.DateTimeFormat;

//import com.fasterxml.jackson.annotation.JsonIgnore;
import fr.projecthandler.dto.GanttTaskDTO;
import fr.projecthandler.util.Utilities;

@Entity
@Table(name = "project")
public class Project extends BaseEntity implements java.io.Serializable {

	private static final long serialVersionUID = 4903605340425810423L;

	@Column(name = "name", length = 30)
	private String name;

	@Column(name = "progress")
	private Long progress;

	@Column(name = "description", length = 500)
	private String description;

	@Column(name = "duration")
	private Long duration;

	@Column(name = "date_begin")
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date dateBegin;

	@Column(name = "date_end")
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date dateEnd;

	@Column(name = "status", length = 30)
	private String status;

	@OneToMany(fetch = FetchType.LAZY, mappedBy = "project")
	private Set<Task> tasks;

	@ManyToMany(fetch = FetchType.LAZY)
	@JoinTable(name = "users_projects", joinColumns = { @JoinColumn(name = "project_id", referencedColumnName = "id") }, inverseJoinColumns = { @JoinColumn(name = "user_id", referencedColumnName = "id") })
	private List<User> users = new ArrayList<User>();

	@OneToMany(fetch = FetchType.LAZY, mappedBy = "project")
	private Set<Ticket> tickets;
	
	public Project() {
	}

	public Project(GanttTaskDTO taskDTO) {
		this.id = Long.parseLong(taskDTO.getId(), 10);
		this.name = Utilities.truncate(taskDTO.getName(), 30);
		this.progress = taskDTO.getProgress();
		this.description = Utilities.truncate(taskDTO.getDescription(), 500);
		this.duration = taskDTO.getDuration();
		this.dateBegin = new Date(taskDTO.getStart());
		this.dateEnd = new Date(taskDTO.getEnd());
		this.status = Utilities.truncate(taskDTO.getStatus(), 30);
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = Utilities.truncate(name, 30);
	}

	public Long getProgress() {
		return progress;
	}

	public void setProgress(Long progress) {
		this.progress = progress;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = Utilities.truncate(description, 500);
	}

	public Long getDuration() {
		return duration;
	}

	public void setDuration(Long duration) {
		this.duration = duration;
	}

	public Date getDateBegin() {
		return dateBegin;
	}

	public void setDateBegin(Date dateBegin) {
		this.dateBegin = dateBegin;
	}

	public Date getDateEnd() {
		return dateEnd;
	}

	public void setDateEnd(Date dateEnd) {
		this.dateEnd = dateEnd;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = Utilities.truncate(status, 30);
	}

	public Set<Task> getTasks() {
		return tasks;
	}

	public void setTasks(Set<Task> tasks) {
		this.tasks = tasks;
	}

	public List<User> getUsers() {
		return users;
	}

	public void setUsers(List<User> users) {
		this.users = users;
	}

	public void addUser(User user) {
		this.users.add(user);
	}

	public void addUsers(List<User> users) {
		this.users.addAll(users);
	}

	public boolean removeUser(User user) {
		return this.users.remove(user);
	}

	public void removeAllUsers() {
		this.users.clear();
	}

	public void removeAllTasks() {
		this.tasks.clear();
	}
}
