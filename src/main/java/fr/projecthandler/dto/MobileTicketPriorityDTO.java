package fr.projecthandler.dto;

import fr.projecthandler.model.TicketPriority;

public class MobileTicketPriorityDTO {

	private Long id;
    private int value;
    private String name;
	
	public MobileTicketPriorityDTO() {
		
	}
	
	public MobileTicketPriorityDTO(TicketPriority ticketPriority) {
		this.id = ticketPriority.getId();
		this.value = ticketPriority.getValue();
		this.name = ticketPriority.getName();
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
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

	public void setName(String name) {
		this.name = name;
	}
}
