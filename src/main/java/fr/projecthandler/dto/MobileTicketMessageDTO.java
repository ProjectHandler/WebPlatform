package fr.projecthandler.dto;

import java.util.Date;

import fr.projecthandler.model.TicketMessage;

public class MobileTicketMessageDTO {

	private MobileUserDTO user;
	private Date createdAt;
	private Date updatedAt;
	private String text;

	public MobileTicketMessageDTO(TicketMessage ticketMessage) {
		this.user = new MobileUserDTO(ticketMessage.getUser());
		this.createdAt = ticketMessage.getCreatedAt();
		this.updatedAt = ticketMessage.getUpdatedAt();
		this.text = ticketMessage.getText();
	}

	public MobileUserDTO getUser() {
		return user;
	}

	public void setUser(MobileUserDTO user) {
		this.user = user;
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

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

}
