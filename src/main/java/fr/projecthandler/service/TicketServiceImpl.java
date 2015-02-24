package fr.projecthandler.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import fr.projecthandler.dao.TicketDao;
import fr.projecthandler.dao.TicketMessageDao;
import fr.projecthandler.dao.TicketTrackerDao;
import fr.projecthandler.model.Ticket;
import fr.projecthandler.model.TicketMessage;
import fr.projecthandler.model.TicketTracker;

@Service
public class TicketServiceImpl implements TicketService {

	@Autowired
	TicketDao ticketDao;

	@Autowired
	TicketMessageDao ticketMessageDao;

	@Autowired
	TicketTrackerDao ticketTrackerDao;

	@Override
	public void saveTicket(Ticket newTicket) {
		ticketDao.saveTicket(newTicket);
	}

	public Ticket findTicketById(Long id) {
		return ticketDao.findTicketById(id);
	}

	@Override
	public void deleteTicketsByIds(List<Long> ticketsIdsList) {
		ticketDao.deleteTicketsByIds(ticketsIdsList);
	}

	@Override
	public void updateTicket(Ticket a) {
		ticketDao.updateTicket(a);
	}

	public List<Ticket> getTicketsByProjectId(Long projectId) {
		return ticketDao.getTicketsByProjectId(projectId);
	}

	@Override
	public List<Ticket> getTicketsByUser(Long id) {
		return ticketDao.getTicketsByUser(id);
	}

	public Long saveTicketMessage(TicketMessage ticketMessage) {
		return ticketMessageDao.saveTicketMessage(ticketMessage);
	}

	public void updateTicketMessage(TicketMessage ticketMessage) {
		ticketMessageDao.updateTicketMessage(ticketMessage);
	}

	public TicketMessage findTicketMessageById(Long ticketMessageId) {
		return ticketMessageDao.findTicketMessageById(ticketMessageId);
	}

	public List<TicketMessage> getTicketMessagesByTicketId(Long ticketId) {
		return ticketMessageDao.getTicketMessagesByTicketId(ticketId);
	}

	public List<TicketMessage> getAllTicketMessages() {
		return ticketMessageDao.getAllTicketMessages();
	}

	public void deleteTicketMessageById(Long ticketMessageId) {
		ticketMessageDao.deleteTicketMessageById(ticketMessageId);
	}

	public void deleteTicketMessagesByIds(List<Long> ticketMessages) {
		ticketMessageDao.deleteTicketMessagesByIds(ticketMessages);
	}

	public TicketTracker findTicketTrackerById(Long id) {
		return ticketTrackerDao.findTicketTrackerById(id);
	}

	public List<TicketTracker> getAllTicketTrackers() {
		return ticketTrackerDao.getAllTicketTrackers();
	}
}
