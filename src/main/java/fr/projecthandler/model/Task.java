package fr.projecthandler.model;

import java.util.Date;
import java.util.List;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;

//import com.fasterxml.jackson.annotation.JsonIgnore;





import org.springframework.format.annotation.DateTimeFormat;

import fr.projecthandler.dto.GanttTaskDTO;
import fr.projecthandler.util.Utilities;

@Entity
@Table(name = "task")
public class Task extends BaseEntity implements java.io.Serializable {

	private static final long serialVersionUID = 5813872400960722390L;

	@Column(name = "name", length = 30)
	private String name;

	@Column(name = "progress")
	private Long progress;

	@Column(name = "description", length = 500)
	private String description;

	@Column(name = "level")
	private Long level;

	@Column(name = "duration")
	private Long duration;

	@Column(name = "starting_date")
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date startingDate;

	@Column(name = "ending_date")
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date endingDate;

	@Column(name = "status", length = 30)
	private String status;

	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "task_priority_id")
	private TaskPriority priority;

	@ManyToMany(fetch = FetchType.LAZY)
	@JoinTable(name = "users_tasks", joinColumns = { @JoinColumn(name = "tasks_id", referencedColumnName = "id") }, inverseJoinColumns = { @JoinColumn(name = "users_id", referencedColumnName = "id") })
	private List<User> users;

	@Column(name = "row")
	private Long row;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "project_id")
	private Project project;

	@ManyToMany(fetch = FetchType.LAZY)
	@JoinTable(name = "depend_tasks", joinColumns = { @JoinColumn(name = "task_id1", referencedColumnName = "id") }, inverseJoinColumns = { @JoinColumn(name = "task_id2", referencedColumnName = "id") })
	private Set<Task> dependtasks;

	@OneToMany(fetch = FetchType.LAZY, mappedBy = "parentTask")
	private Set<SubTask> subtasks;
	
	@OneToMany(fetch = FetchType.LAZY, mappedBy = "task")
	private Set<TaskMessage> taskMessages;
	
	public Task() {
	}

	public Task(GanttTaskDTO taskDTO) {
		// if (taskDTO.getId() != null)
		// this.id = Long.parseLong(taskDTO.getId(), 10);
		this.name = Utilities.truncate(taskDTO.getName(), 30);
		this.progress = taskDTO.getProgress();
		this.description = Utilities.truncate(taskDTO.getDescription(), 500);
		this.level = taskDTO.getLevel();
		this.duration = taskDTO.getDuration();
		this.startingDate = new Date(taskDTO.getStart());
		this.endingDate = new Date(taskDTO.getEnd());
		this.status = Utilities.truncate(taskDTO.getStatus(), 30);
	}

	public TaskPriority getPriority() {
		return priority;
	}

	public void setPriority(TaskPriority priority) {
		this.priority = priority;
	}

	public List<User> getUsers() {
		return users;
	}

	public void setUsers(List<User> users) {
		this.users = users;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = Utilities.truncate(name, 30);
	}

	public Long getProgress() {
		return this.progress;
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

	public Long getLevel() {
		return this.level;
	}

	public void setLevel(Long level) {
		this.level = level;
	}

	public Long getDuration() {
		return this.duration;
	}

	public void setDuration(Long duration) {
		this.duration = duration;
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

	public Long getRow() {
		return row;
	}

	public void setRow(Long row) {
		this.row = row;
	}

	public Project getProject() {
		return project;
	}

	public void setProject(Project project) {
		this.project = project;
	}

	public Set<Task> getDepend() {
		return dependtasks;
	}

	public void setDepend(Set<Task> depend) {
		this.dependtasks = depend;
	}

	public Set<Task> getDependtasks() {
		return dependtasks;
	}

	public void setDependtasks(Set<Task> dependtasks) {
		this.dependtasks = dependtasks;
	}

	public Set<SubTask> getSubtasks() {
		return subtasks;
	}

	public void setSubtasks(Set<SubTask> subtasks) {
		this.subtasks = subtasks;
	}

	public Set<TaskMessage> getTaskMessages() {
		return taskMessages;
	}

	public void setTaskMessages(Set<TaskMessage> taskMessages) {
		this.taskMessages = taskMessages;
	}
}