package fr.projecthandler.enums;

import java.util.Arrays;

public enum TaskLevel {
	PROJECT(0l, "Project"), MILESTONE(1l, "Milestone"), TASK(2l, "Task");
	
	private Long id;		// Long to match task level type
	private String value;
	
	TaskLevel(Long id, String value) {
		this.id = id;
		this.value = value;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}
	
	public String getValueById(Integer id) {
		if (id != null) {
			return Arrays.asList(TaskLevel.values()).get(id).getValue();
		}
		return null;
	}
}
