package fr.projecthandler.dto;

import fr.projecthandler.model.User;

public class GanttResourceDTO {

	private String id;
	private String name;
	
	public GanttResourceDTO() {
		
	}
	
	public GanttResourceDTO(User user) {
		this.id = user.getId().toString();
		this.name = user.getFirstName() + " " + user.getLastName();
	}
	
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	
	
}
