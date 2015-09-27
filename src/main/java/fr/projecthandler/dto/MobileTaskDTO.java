package fr.projecthandler.dto;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import fr.projecthandler.model.Task;

public class MobileTaskDTO {

    private Long id;
    private String name;
    private String description;
    private Long progress;
    private Long level;
    private Long duration;
    private Date startingDate;
    private Date endingDate;
    private String status;
    private List<MobileUserDTO> users;
    private Long row;
    private Set<MobileTaskDTO> dependtasks;
    private Set<MobileSubTaskDTO> mobileSubTaskDTO;
    
    public MobileTaskDTO() {
    	
    }
    
    public MobileTaskDTO(Task task) {
        this.id = task.getId();
        this.name = task.getName();
        this.description = task.getDescription();
        this.progress = task.getProgress();
        this.level = task.getLevel();
        this.duration = task.getDuration();
        this.startingDate = task.getStartingDate();
        this.endingDate = task.getEndingDate();
        this.status = task.getStatus();
        this.users = new ArrayList<MobileUserDTO>();
        this.row = task.getRow();
        this.dependtasks = new HashSet<MobileTaskDTO>();
        /*for (User u : task.getUsers()) {
        	this.users.add(new MobileUserDTO(u));
        } */
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

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public Long getProgress() {
		return progress;
	}

	public void setProgress(Long progress) {
		this.progress = progress;
	}

	public Long getLevel() {
		return level;
	}

	public void setLevel(Long level) {
		this.level = level;
	}

	public Long getDuration() {
		return duration;
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

	public List<MobileUserDTO> getUsers() {
		return users;
	}

	public void setUsers(List<MobileUserDTO> users) {
		this.users = users;
	}

	public Long getRow() {
		return row;
	}

	public void setRow(Long row) {
		this.row = row;
	}

	public Set<MobileTaskDTO> getDependtasks() {
		return dependtasks;
	}

	public void setDependtasks(Set<MobileTaskDTO> dependtasks) {
		this.dependtasks = dependtasks;
	}

	public Set<MobileSubTaskDTO> getMobileSubTaskDTO() {
	    return mobileSubTaskDTO;
	}

	public void setMobileSubTaskDTO(Set<MobileSubTaskDTO> mobileSubTaskDTO) {
	    this.mobileSubTaskDTO = mobileSubTaskDTO;
	}
    
}
