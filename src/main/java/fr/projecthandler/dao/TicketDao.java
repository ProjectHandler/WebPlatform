package fr.projecthandler.dao;

import java.util.List;

import fr.projecthandler.model.Ticket;

public interface TicketDao {

	public void save(Ticket Ticket);

	public Ticket getTicketById(Long id);
	
	public List<Ticket> getTicketByUser(Long id);

	public void updateTicket(Ticket Ticket);

	public void deleteTicketById(Long id);
	
	public void deleteTicketByListIds(List<Long> TicketesIdsList);
}
