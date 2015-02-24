package fr.projecthandler.service;

import java.util.List;

import fr.projecthandler.model.Ticket;
import fr.projecthandler.model.TicketMessage;
import fr.projecthandler.model.TicketTracker;

public interface TicketService {

	public void saveTicket(Ticket newTicket);

	public Ticket findTicketById(Long id);

	public List<Ticket> getTicketsByUser(Long id);

	public void updateTicket(Ticket t);

	public void deleteTicketsByIds(List<Long> ticketsIdsList);

	public List<Ticket> getTicketsByProjectId(Long projectId);

	public Long saveTicketMessage(TicketMessage ticketMessage);

	public void updateTicketMessage(TicketMessage ticketMessage);

	public TicketMessage findTicketMessageById(Long ticketMessageId);

	public List<TicketMessage> getTicketMessagesByTicketId(Long ticketId);

	public List<TicketMessage> getAllTicketMessages();

	public void deleteTicketMessageById(Long ticketMessageId);

	public void deleteTicketMessagesByIds(List<Long> ticketMessages);

	public TicketTracker findTicketTrackerById(Long id);

	public List<TicketTracker> getAllTicketTrackers();

}
