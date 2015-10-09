package fr.projecthandler.dao;

import java.util.List;

import fr.projecthandler.model.TicketPriority;

public interface TicketPriorityDao {

	public Long saveTicketPriority(TicketPriority ticketPriority);

	public void updateTicketPriority(TicketPriority ticketPriority);

	public void deleteTicketPriorityById(Long ticketPriorityId);

	public void deleteTicketPrioritiesByIds(List<Long> ticketPriorities);

	public TicketPriority findTicketPriorityById(Long ticketPriorityId);

	public List<TicketPriority> getAllTicketPriorities();
}