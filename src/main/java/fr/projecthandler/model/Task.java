package fr.projecthandler.model;

import java.util.Date;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Transient;

import fr.projecthandler.dto.GanttTaskDTO;

@Entity
@Table(name = "task")
public class Task extends BaseEntity implements java.io.Serializable {

	private static final long serialVersionUID = 5813872400960722390L;

	@Column(name = "name")
	private String name;

	@Column(name = "progress")
	private Long progress;

	@Column(name = "description")
	private String description;

	@Column(name = "level")
	private Long level;

	@Column(name = "duration")
	private Long duration;

	@Column(name = "starting_date")
	private Date startingDate;

	@Column(name = "ending_date")
	private Date endingDate;

	@Column(name = "status", length = 30)
	private String status;

	//@Column(name = "row")
	@Transient
	private Long row;
	
	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "project_id")
	private Project project;

	@ManyToMany(fetch = FetchType.LAZY)
	@JoinTable(name = "depend_Tasks", joinColumns = { @JoinColumn(name = "task_id1", referencedColumnName = "id") }, 
			inverseJoinColumns = { @JoinColumn(name = "task_id2", referencedColumnName = "id") })
	private Set<Task> dependtasks;
	
	public Task() {
	}

	public Task(GanttTaskDTO taskDTO) {
		//if (taskDTO.getId() != null)
		//	this.id = Long.parseLong(taskDTO.getId(), 10);
		this.name = taskDTO.getName();
		this.progress = taskDTO.getProgress();
		this.description = taskDTO.getDescription();
		this.level = taskDTO.getLevel() - 1;
		this.duration = taskDTO.getDuration();
		this.startingDate = new Date(taskDTO.getStart());
		this.endingDate = new Date(taskDTO.getEnd());
		this.status = taskDTO.getStatus();
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
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
		this.description = description;
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
		this.status = status;
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
	
	
}