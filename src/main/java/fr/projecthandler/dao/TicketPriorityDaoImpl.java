package fr.projecthandler.dao;

import java.util.List;

import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import fr.projecthandler.model.TicketPriority;
import fr.projecthandler.util.Utilities;

@Component
public class TicketPriorityDaoImpl extends AbstractDao implements TicketPriorityDao {

	@Override
	@Transactional
	public void updateTicketPriority(TicketPriority ticketPriority) {
		em.merge(ticketPriority);
	}

	@Override
	@Transactional
	public Long saveTicketPriority(TicketPriority ticketPriority) {
		em.persist(ticketPriority);

		return ticketPriority.getId();
	}

	@Override
	@Transactional
	public void deleteTicketPrioritiesByIds(List<Long> ticketPrioritiesIdsList) {
		em.createQuery("DELETE FROM TicketPriority tt WHERE tt.id IN (:ticketPrioritiesIdsList)")
				.setParameter("ticketPrioritiesIdsList", ticketPrioritiesIdsList).executeUpdate();
	}

	@Override
	@Transactional
	public void deleteTicketPriorityById(Long ticketPriorityId) {
		em.createQuery("DELETE FROM TicketPriority tt WHERE tt.id = :ticketPriorityId").setParameter("ticketPriorityId", ticketPriorityId)
				.executeUpdate();
	}

	@Override
	public TicketPriority findTicketPriorityById(Long ticketPriorityId) {
		return (TicketPriority) Utilities.getSingleResultOrNull(em.createQuery("SELECT tt FROM TicketPriority tt WHERE tt.id = :ticketPriorityId")
				.setParameter("ticketPriorityId", ticketPriorityId));
	}

	@Override
	public List<TicketPriority> getAllTicketPriorities() {
		return (List<TicketPriority>) em.createQuery("SELECT tt FROM TicketPriority tt").getResultList();
	}

}