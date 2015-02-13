package fr.projecthandler.enums;

import java.io.Serializable;

public enum TicketStatus implements Serializable {

	CLOSED(0, "closed"), OPEN(1, "open");

	private Integer id;
	private String value;

	private TicketStatus(Integer id, String value) {
		this.id = id;
		this.value = value;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}
	
	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	public static TicketStatus findById(Integer code) {
		if (code != null) {
			for (TicketStatus ticketStatus : TicketStatus.values()) {
				if (code.equals(ticketStatus.getId())) {
					return ticketStatus;
				}
			}
		}
		return null;
	}

	public static TicketStatus findByValue(String value) {
		if (value != null) {
			for (TicketStatus ticketStatus : TicketStatus.values()) {
				if (value.equals(ticketStatus.getValue())) {
					return ticketStatus;
				}
			}
		}
		
		return null;
	}
}