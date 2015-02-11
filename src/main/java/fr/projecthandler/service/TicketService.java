package fr.projecthandler.service;

import java.util.List;

import fr.projecthandler.model.Ticket;

public interface TicketService {
	
	public void saveTicket(Ticket newTicket);
	
	public List<Ticket> getTicketByUser(Long id);
	
	public void updateTicket(Ticket t);
	
	public void deleteTicketByIds(List<Long> ticketsIdsList);
}
