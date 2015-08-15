package fr.projecthandler.dto;

import fr.projecthandler.model.TicketTracker;

public class MobileTicketTrackerDTO {

	 private Long id;
	 private String name;
	
	public MobileTicketTrackerDTO() {
		
	}
	
	public MobileTicketTrackerDTO(TicketTracker ticketTraker) {
		 this.id = ticketTraker.getId();
		 this.name = ticketTraker.getName();
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
	
}
