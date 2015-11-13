package fr.projecthandler.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import fr.projecthandler.dao.TicketDao;
import fr.projecthandler.dao.TicketMessageDao;
import fr.projecthandler.dao.TicketPriorityDao;
import fr.projecthandler.dao.TicketTrackerDao;
import fr.projecthandler.model.Ticket;
import fr.projecthandler.model.TicketMessage;
import fr.projecthandler.model.TicketPriority;
import fr.projecthandler.model.TicketTracker;

@Service
public class TicketServiceImpl implements TicketService {

	@Autowired
	TicketDao ticketDao;

	@Autowired
	TicketMessageDao ticketMessageDao;

	@Autowired
	TicketTrackerDao ticketTrackerDao;

	@Autowired
	TicketPriorityDao ticketPriorityDao;

	@Override
	public void saveTicket(Ticket newTicket) {
		ticketDao.saveTicket(newTicket);
	}

	@Override
	public Ticket findTicketById(Long id) {
		return ticketDao.findTicketById(id);
	}

	@Override
	public void deleteTicketsByIds(List<Long> ticketsIdsList) {
		ticketDao.deleteTicketsByIds(ticketsIdsList);
	}

	@Override
	public void deleteTicketById(Long id) {
		ticketDao.deleteTicketById(id);
	}

	@Override
	public void updateTicket(Ticket a) {
		ticketDao.updateTicket(a);
	}

	@Override
	public List<Ticket> getTicketsByProjectId(Long projectId) {
		return ticketDao.getTicketsByProjectId(projectId);
	}

	@Override
	public List<Ticket> getTicketsByProjectIdAndOrderByDesc(Long projectId, int maxResults) {
		return ticketDao.getTicketsByProjectIdAndOrderByDesc(projectId, maxResults);
	}

	public List<Ticket> getTicketsByProjectIdWithAuthor(Long projectId) {
		return ticketDao.getTicketsByProjectIdWithAuthor(projectId);
	}

	@Override
	public List<Ticket> getTicketsByUser(Long id) {
		return ticketDao.getTicketsByUser(id);
	}

	@Override
	public Long saveTicketMessage(TicketMessage ticketMessage) {
		return ticketMessageDao.saveTicketMessage(ticketMessage);
	}

	@Override
	public void updateTicketMessage(TicketMessage ticketMessage) {
		ticketMessageDao.updateTicketMessage(ticketMessage);
	}

	@Override
	public TicketMessage findTicketMessageById(Long ticketMessageId) {
		return ticketMessageDao.findTicketMessageById(ticketMessageId);
	}

	@Override
	public List<TicketMessage> getTicketMessagesByTicketId(Long ticketId) {
		return ticketMessageDao.getTicketMessagesByTicketId(ticketId);
	}

	@Override
	public List<TicketMessage> getAllTicketMessages() {
		return ticketMessageDao.getAllTicketMessages();
	}

	@Override
	public void deleteTicketMessageById(Long ticketMessageId) {
		ticketMessageDao.deleteTicketMessageById(ticketMessageId);
	}

	@Override
	public void deleteTicketMessagesByIds(List<Long> ticketMessages) {
		ticketMessageDao.deleteTicketMessagesByIds(ticketMessages);
	}

	@Override
	public TicketTracker findTicketTrackerById(Long id) {
		return ticketTrackerDao.findTicketTrackerById(id);
	}

	@Override
	public List<TicketTracker> getAllTicketTrackers() {
		return ticketTrackerDao.getAllTicketTrackers();
	}

	@Override
	public Long saveTicketPriority(TicketPriority ticketPriority) {
		return ticketPriorityDao.saveTicketPriority(ticketPriority);
	}

	@Override
	public void updateTicketPriority(TicketPriority ticketPriority) {
		ticketPriorityDao.updateTicketPriority(ticketPriority);
	}

	@Override
	public void deleteTicketPriorityById(Long ticketPriorityId) {
		ticketPriorityDao.deleteTicketPriorityById(ticketPriorityId);
	}

	@Override
	public void deleteTicketPrioritiesByIds(List<Long> ticketPriorities) {
		ticketPriorityDao.deleteTicketPrioritiesByIds(ticketPriorities);
	}

	@Override
	public TicketPriority findTicketPriorityById(Long ticketPriorityId) {
		return ticketPriorityDao.findTicketPriorityById(ticketPriorityId);
	}

	@Override
	public List<TicketPriority> getAllTicketPriorities() {
		return ticketPriorityDao.getAllTicketPriorities();
	}
	
	@Override
	public Ticket findTicketByIdAndFetchUser(Long ticketId) {
		return ticketDao.findTicketByIdAndFetchUsers(ticketId);
	}

	@Override
	public Ticket findTicketByIdAndFetchAuthor(Long ticketId) {
		return ticketDao.findTicketByIdAndFetchAuthor(ticketId);
	}

	@Override
	public Ticket findTicketByIdAndFetchAuthorAndProject(Long ticketId) {
		return ticketDao.findTicketByIdAndFetchAuthorAndProject(ticketId);
	}

	@Override
	public List<TicketMessage> getTicketMessagesByTicketIdAndFetchUser(Long ticketId) {
		return ticketMessageDao.getTicketMessagesByTicketIdAndFetchUser(ticketId);
	}
	
	@Override
	public List<Ticket> getTicketsByProjectIdAndUser(Long projectId, Long userId) {
		return ticketDao.getTicketsByProjectIdAndUser(projectId, userId);
	}
}
