package fr.projecthandler.dto;

import java.util.Date;

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

}