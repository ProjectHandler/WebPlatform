package fr.projecthandler.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "ticket_priority")
public class TicketPriority extends BaseEntity implements java.io.Serializable {

	private static final long serialVersionUID = -2826485022843603488L;

	@Column(name = "value")
	private int value;

	@Column(name = "name", length = 50)
	private String name;

	public TicketPriority() {
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
