package fr.projecthandler.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import fr.projecthandler.dao.TicketDao;
import fr.projecthandler.model.Ticket;

@Service
public class TicketServiceImpl implements TicketService {
	
	@Autowired
	TicketDao ticketDao;

	@Override
	public void saveTicket(Ticket newTicket) {
		ticketDao.save(newTicket);
	}

	@Override
	public void deleteTicketByIds(List<Long> ticketsIdsList) {
		ticketDao.deleteTicketByListIds(ticketsIdsList);
	}
	
	@Override
	public void updateTicket(Ticket a) {
		ticketDao.updateTicket(a);
	}

	@Override
	public List<Ticket> getTicketByUser(Long id) {
		return ticketDao.getTicketByUser(id);
	}
	
}
