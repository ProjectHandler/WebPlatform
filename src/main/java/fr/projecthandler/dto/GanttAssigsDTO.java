package fr.projecthandler.dto;

public class GanttAssigsDTO {

	private String id;
	private String resourceId;
	private String roleId;
	private Long effort;

	public GanttAssigsDTO() {
		this.roleId = null;
		this.effort = 0l;
	}
	
	public String getId() {
		return id;
	}
	
	public void setId(String id) {
		this.id = id;
	}
	
	public String getResourceId() {
		return resourceId;
	}
	
	public void setResourceId(String resourceId) {
		this.resourceId = resourceId;
	}
	
	public String getRoleId() {
		return roleId;
	}
	
	public void setRoleId(String roleId) {
		this.roleId = roleId;
	}
	
	public Long getEffort() {
		return effort;
	}
	
	public void setEffort(Long effort) {
		this.effort = effort;
	}
}
