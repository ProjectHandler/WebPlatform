package fr.projecthanlder.dto;

import java.util.ArrayList;
import java.util.List;

public class GanttProjectDTO {

	private List<GanttTaskDTO> tasks;
	private List<GanttResourceDTO> resources;
	private List<GanttRoleDTO> roles;
	private boolean canWrite;
	private boolean canWriteOnParent;
	private long selectedRow;
	private List<String> deletedTaskIds;

	public GanttProjectDTO() {
		this.tasks = new ArrayList<GanttTaskDTO>(); 
		this.resources = new ArrayList<GanttResourceDTO>(); 
		this.roles = new ArrayList<GanttRoleDTO>(); 
		this.canWrite = true;
		this.canWriteOnParent = true;
		this.selectedRow = 0l;
		this.deletedTaskIds = new ArrayList<String>(); 
	}
	
	public List<GanttTaskDTO> getTasks() {
		return tasks;
	}

	public void setTasks(List<GanttTaskDTO> tasks) {
		this.tasks = tasks;
	}

	public List<GanttResourceDTO> getResources() {
		return resources;
	}

	public void setResources(List<GanttResourceDTO> resources) {
		this.resources = resources;
	}

	public List<GanttRoleDTO> getRoles() {
		return roles;
	}

	public void setRoles(List<GanttRoleDTO> roles) {
		this.roles = roles;
	}

	public boolean isCanWrite() {
		return canWrite;
	}

	public void setCanWrite(boolean canWrite) {
		this.canWrite = canWrite;
	}

	public boolean isCanWriteOnParent() {
		return canWriteOnParent;
	}

	public void setCanWriteOnParent(boolean canWriteOnParent) {
		this.canWriteOnParent = canWriteOnParent;
	}

	public long getSelectedRow() {
		return selectedRow;
	}

	public void setSelectedRow(long selectedRow) {
		this.selectedRow = selectedRow;
	}

	public List<String> getDeletedTaskIds() {
		return deletedTaskIds;
	}

	public void setDeletedTaskIds(List<String> deletedTaskIds) {
		this.deletedTaskIds = deletedTaskIds;
	}
}
