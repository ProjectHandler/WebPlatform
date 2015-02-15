package fr.projecthandler.dao;

import java.util.List;

import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import fr.projecthandler.model.TicketMessage;
import fr.projecthandler.util.Utilities;

@Component
public class TicketMessageDaoImpl extends AbstractDao implements TicketMessageDao {

	@Override
	@Transactional
	public void updateTicketMessage(TicketMessage ticketMessage) {
		em.merge(ticketMessage);
	}

	@Override
	@Transactional
	public Long saveTicketMessage(TicketMessage ticketMessage) {
		em.persist(ticketMessage);
		
		return ticketMessage.getId();
	}

	@Override
	@Transactional
	public void deleteTicketMessageByListIds(List<Long> ticketMessagesIdsList) {
		em.createQuery("DELETE FROM TicketMessage tm WHERE tm.id IN (:ticketMessagesIdsList)")
		.setParameter("ticketMessagesIdsList", ticketMessagesIdsList)
		.executeUpdate();
	}

	@Override
	@Transactional
	public void deleteTicketMessageById(Long ticketMessageId) {
		em.createQuery("DELETE FROM TicketMessage tm WHERE tm.id = :ticketMessageId")
		.setParameter("ticketMessageId", ticketMessageId)
		.executeUpdate();
	}
	@Override
	public TicketMessage findTicketMessageById(Long ticketMessageId) {
		return (TicketMessage) Utilities.getSingleResultOrNull(em.createQuery("SELECT tm FROM TicketMessage tm WHERE tm.id = :ticketMessageId")
				.setParameter("ticketMessageId", ticketMessageId));
	}

	@Override
	public List<TicketMessage> getTicketMessagesByTicketId(Long ticketId) {
		return (List<TicketMessage>)em.createQuery("FROM TicketMessage tm WHERE tm.ticket.id = :ticketId")
				.setParameter("ticketId", ticketId)
				.getResultList();
	}

	@Override
	public List<TicketMessage> getAllTicketMessages() {
		return (List<TicketMessage>)em.createQuery("SELECT tm FROM TicketMessage tm")
				.getResultList();
	}

}