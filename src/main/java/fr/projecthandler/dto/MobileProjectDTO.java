package fr.projecthandler.dto;

import java.util.Date;
import java.util.List;

import fr.projecthandler.model.Project;

public class MobileProjectDTO {

	private Long id;
	private String name;
	private Long progress;
	private String description;
	private Long duration;
	private Date dateBegin;
	private Date dateEnd;
	private String status;
	private Integer dateProgress;
	private Integer daysLeft;
	private Integer tasksProgress;
	private List<MobileUserDTO> users;
	
	public MobileProjectDTO() {
	}

	public MobileProjectDTO(Project project) {
		this.id = project.getId();
		this.name = project.getName();
		this.progress = project.getProgress();
		this.description = project.getDescription();
		this.duration = project.getDuration();
		this.dateBegin = project.getDateBegin();
		this.dateEnd = project.getDateEnd();
		this.status = project.getStatus();
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
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
		this.description = description;
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
		this.status = status;
	}

	public Integer getDateProgress() {
		return dateProgress;
	}

	public void setDateProgress(Integer dateProgress) {
		this.dateProgress = dateProgress;
	}

	public Integer getDaysLeft() {
		return daysLeft;
	}

	public void setDaysLeft(Integer daysLeft) {
		this.daysLeft = daysLeft;
	}

	public Integer getTasksProgress() {
		return tasksProgress;
	}

	public void setTasksProgress(Integer tasksProgress) {
		this.tasksProgress = tasksProgress;
	}

	public List<MobileUserDTO> getUsers() {
		return users;
	}

	public void setUsers(List<MobileUserDTO> users) {
		this.users = users;
	}

}
