package fr.projecthandler.dto;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import fr.projecthandler.enums.TicketStatus;
import fr.projecthandler.model.Ticket;
import fr.projecthandler.model.TicketMessage;

public class MobileTicketDTO {

	private Long id;
	private String title;
	private String text;
	private TicketStatus ticketStatus;
	private Long projectId;
	private MobileTicketTrackerDTO ticketTracker;
	private MobileTicketPriorityDTO ticketPriority;
	private List<MobileTicketMessageDTO> ticketMessage;
	private Date createdAt;
	private Date updatedAt;

	public MobileTicketDTO() {
	}

	public MobileTicketDTO(Ticket ticket) {
		this.id = ticket.getId();
		this.title = ticket.getTitle();
		this.text = ticket.getText();
		this.ticketStatus = ticket.getTicketStatus();
		this.projectId = ticket.getProject().getId();
		if (ticket.getTicketTracker() != null)
			this.ticketTracker = new MobileTicketTrackerDTO(ticket.getTicketTracker());
		if (ticket.getTicketPriority() != null)
			this.ticketPriority = new MobileTicketPriorityDTO(ticket.getTicketPriority());
		this.createdAt = ticket.getCreatedAt();
		this.updatedAt = ticket.getUpdatedAt();

	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

	public TicketStatus getTicketStatus() {
		return ticketStatus;
	}

	public void setTicketStatus(TicketStatus ticketStatus) {
		this.ticketStatus = ticketStatus;
	}

	public Long getProjectId() {
		return projectId;
	}

	public void setProjectId(Long projectId) {
		this.projectId = projectId;
	}

	public MobileTicketTrackerDTO getTicketTracker() {
		return ticketTracker;
	}

	public void setTicketTracker(MobileTicketTrackerDTO ticketTracker) {
		this.ticketTracker = ticketTracker;
	}

	public MobileTicketPriorityDTO getTicketPriority() {
		return ticketPriority;
	}

	public void setTicketPriority(MobileTicketPriorityDTO ticketPriority) {
		this.ticketPriority = ticketPriority;
	}

	public List<MobileTicketMessageDTO> getTicketMessage() {
		return ticketMessage;
	}

	public void setTicketMessage(List<MobileTicketMessageDTO> ticketMessage) {
		this.ticketMessage = ticketMessage;
	}

	public void setMessage(List<TicketMessage> listTicketMessage) {
		List<MobileTicketMessageDTO> ticketMessageDTO = new ArrayList<MobileTicketMessageDTO>();
		for (TicketMessage message : listTicketMessage) {
			ticketMessageDTO.add(new MobileTicketMessageDTO(message));
		}
	}

	public Date getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}

	public Date getUpdatedAt() {
		return updatedAt;
	}

	public void setUpdatedAt(Date updatedAt) {
		this.updatedAt = updatedAt;
	}

}
