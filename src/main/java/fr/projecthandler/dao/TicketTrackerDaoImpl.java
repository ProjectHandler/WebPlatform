package fr.projecthandler.dao;

import java.util.List;

import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import fr.projecthandler.model.TicketTracker;
import fr.projecthandler.util.Utilities;

@Component
public class TicketTrackerDaoImpl extends AbstractDao implements TicketTrackerDao {

	@Override
	@Transactional
	public void updateTicketTracker(TicketTracker ticketTracker) {
		em.merge(ticketTracker);
	}

	@Override
	@Transactional
	public Long saveTicketTracker(TicketTracker ticketTracker) {
		em.persist(ticketTracker);
		
		return ticketTracker.getId();
	}

	@Override
	@Transactional
	public void deleteTicketTrackersByIds(List<Long> ticketTrackersIdsList) {
		em.createQuery("DELETE FROM TicketTracker tt WHERE tt.id IN (:ticketTrackersIdsList)")
		.setParameter("ticketTrackersIdsList", ticketTrackersIdsList)
		.executeUpdate();
	}

	@Override
	@Transactional
	public void deleteTicketTrackerById(Long ticketTrackerId) {
		em.createQuery("DELETE FROM TicketTracker tt WHERE tt.id = :ticketTrackerId")
		.setParameter("ticketTrackerId", ticketTrackerId)
		.executeUpdate();
	}
	@Override
	public TicketTracker findTicketTrackerById(Long ticketTrackerId) {
		return (TicketTracker) Utilities.getSingleResultOrNull(em.createQuery("SELECT tt FROM TicketTracker tt WHERE tt.id = :ticketTrackerId")
				.setParameter("ticketTrackerId", ticketTrackerId));
	}

	@Override
	public List<TicketTracker> getTicketTrackersByTicketId(Long ticketId) {
		return (List<TicketTracker>)em.createQuery("FROM TicketTracker tt WHERE tt.ticket.id = :ticketId")
				.setParameter("ticketId", ticketId)
				.getResultList();
	}

	@Override
	public List<TicketTracker> getAllTicketTrackers() {
		return (List<TicketTracker>)em.createQuery("SELECT tt FROM TicketTracker tt")
				.getResultList();
	}

}