package fr.projecthandler.dto;

import fr.projecthandler.model.SubTask;

public class MobileSubTaskDTO {

	private Long id;
	private String description;
	private boolean validated;
	private boolean taken;

	public MobileSubTaskDTO() {
	    
	}
	
	public MobileSubTaskDTO(SubTask subTask) {
		this.id = subTask.getId();
		this.description = subTask.getDescription();
		this.validated = subTask.isValidated();
		this.taken = subTask.isTaken();
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getDescription() {
	    return description;
	}

	public void setDescription(String description) {
	    this.description = description;
	}

	public boolean isValidated() {
	    return validated;
	}

	public void setValidated(boolean validated) {
	    this.validated = validated;
	}

	public boolean isTaken() {
	    return taken;
	}

	public void setTaken(boolean taken) {
	    this.taken = taken;
	}
	
}
