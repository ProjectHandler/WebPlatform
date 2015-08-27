package fr.projecthandler.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "task_priority")
public class TaskPriority extends BaseEntity implements java.io.Serializable {

	private static final long serialVersionUID = 6885435809656538457L;

	@Column(name = "value")
	private int value;

	@Column(name = "name", length = 50)
	private String name;

	public TaskPriority() {
	}

	public int getValue() {
		return value;
	}

	public void setValue(int value) {
		this.value = value;
	}

	public String getName() {
		return name;
	}

	public void setName(final String name) {
		this.name = name;
	}

}

