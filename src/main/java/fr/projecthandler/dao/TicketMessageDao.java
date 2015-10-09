package fr.projecthandler.dao;

import java.util.List;

import fr.projecthandler.model.TicketMessage;

public interface TicketMessageDao {

	public Long saveTicketMessage(TicketMessage ticketMessage);

	public void updateTicketMessage(TicketMessage ticketMessage);

	public void deleteTicketMessageById(Long ticketMessageId);

	public void deleteTicketMessagesByIds(List<Long> ticketMessages);

	public TicketMessage findTicketMessageById(Long ticketMessageId);

	public List<TicketMessage> getTicketMessagesByTicketId(Long ticketId);

	public List<TicketMessage> getAllTicketMessages();
}