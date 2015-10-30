package fr.projecthandler.dao;

import java.util.List;

import fr.projecthandler.model.Ticket;

public interface TicketDao {

	public Long saveTicket(Ticket Ticket);

	public void updateTicket(Ticket Ticket);

	public void deleteTicketById(Long id);

	public void deleteTicketsByIds(List<Long> TicketesIdsList);

	public Ticket findTicketById(Long id);

	public List<Ticket> getTicketsByUser(Long id);

	public List<Ticket> getTicketsByProjectId(Long projectId);

	public Ticket findTicketByIdAndFetchUsers(Long ticketId);
	
	public Ticket findTicketByIdAndFetchAuthor(Long ticketId);
	
	public List<Ticket> getTicketsByProjectIdAndUser(Long projectId, Long userId);

}
