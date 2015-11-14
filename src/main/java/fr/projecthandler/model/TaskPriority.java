package fr.projecthandler.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

import fr.projecthandler.enums.Priority;
import fr.projecthandler.util.Utilities;

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
	

	public TaskPriority(Priority priority) {
		this.id = new Long(priority.getValue());
		this.value = priority.getValue();
		this.name = Utilities.truncate(priority.getName(), 50);
	}
	
	public TaskPriority(Integer id) {
		this.id = new Long(id);
		this.value = id;
		this.name = Priority.findByValue(id);
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
		this.name = Utilities.truncate(name, 50);
	}

}
