package fr.projecthandler.dao;

import java.util.List;

import fr.projecthandler.model.TicketMessage;
import fr.projecthandler.model.User;

public interface TicketMessageDao {
	
	public Long saveTicketMessage(TicketMessage ticketMessage);

	public void updateTicketMessage(TicketMessage ticketMessage);

	public TicketMessage findTicketMessageById(Long ticketMessageId);

	public List<TicketMessage> findTicketMessagesByTicketId(Long ticketId);

	public List<TicketMessage> getAllTicketMessages();

	public void deleteTicketMessageById(Long ticketMessageId);

	public void deleteTicketMessageByListIds(List<Long> ticketMessages);
}