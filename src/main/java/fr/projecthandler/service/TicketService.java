package fr.projecthandler.service;

import java.util.List;

import fr.projecthandler.model.Ticket;
import fr.projecthandler.model.TicketMessage;
import fr.projecthandler.model.TicketPriority;
import fr.projecthandler.model.TicketTracker;

public interface TicketService {

	public void saveTicket(Ticket newTicket);

	public Ticket findTicketById(Long id);

	public List<Ticket> getTicketsByUser(Long id);

	public void updateTicket(Ticket t);

	public void deleteTicketById(Long id);

	public void deleteTicketsByIds(List<Long> ticketsIdsList);

	public List<Ticket> getTicketsByProjectId(Long projectId);

	public List<Ticket> getTicketsByProjectIdAndOrderByDesc(Long projectId, int maxResults);

	public List<Ticket> getTicketsByProjectIdWithAuthor(Long projectId);

	public Long saveTicketMessage(TicketMessage ticketMessage);

	public void updateTicketMessage(TicketMessage ticketMessage);

	public TicketMessage findTicketMessageById(Long ticketMessageId);

	public List<TicketMessage> getTicketMessagesByTicketId(Long ticketId);

	public List<TicketMessage> getAllTicketMessages();

	public void deleteTicketMessageById(Long ticketMessageId);

	public void deleteTicketMessagesByIds(List<Long> ticketMessages);

	public TicketTracker findTicketTrackerById(Long id);

	public List<TicketTracker> getAllTicketTrackers();

	public Long saveTicketPriority(TicketPriority ticketPriority);

	public void updateTicketPriority(TicketPriority ticketPriority);

	public void deleteTicketPriorityById(Long ticketPriorityId);

	public void deleteTicketPrioritiesByIds(List<Long> ticketPriorities);

	public TicketPriority findTicketPriorityById(Long ticketPriorityId);

	public List<TicketPriority> getAllTicketPriorities();
	
	public Ticket findTicketByIdAndFetchUser(Long ticketIdd);
	
	public Ticket findTicketByIdAndFetchAuthor(Long ticketId);
	
	public List<TicketMessage>  getTicketMessagesByTicketIdAndFetchUser(Long ticketId);

	public List<Ticket> getTicketsByProjectIdAndUser(Long projectId, Long userId);
}
