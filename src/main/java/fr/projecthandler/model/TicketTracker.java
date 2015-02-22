package fr.projecthandler.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "ticket_tracker")
public class TicketTracker extends BaseEntity implements java.io.Serializable {

	private static final long serialVersionUID = -2826485022843603488L;

	@Column(name = "name", length = 50)
	private String name;

	public TicketTracker() {
	}

	public String getName() {
		return name;
	}

	public void setName(final String name) {
		this.name = name;
	}

}
