package fr.projecthandler.dao;

import java.util.List;

import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import fr.projecthandler.model.Ticket;
import fr.projecthandler.util.Utilities;

@Component
public class TicketDaoImpl extends AbstractDao implements TicketDao {

	@Override
	@Transactional
	public Long saveTicket(Ticket ticket) {
		em.persist(ticket);

		return ticket.getId();
	}

	@Override
	@Transactional
	public void updateTicket(Ticket ticket) {
		em.merge(ticket);
	}

	@Override
	public void deleteTicketById(Long id) {
		em.createQuery("DELETE FROM Ticket t WHERE t.id =:id").setParameter("id", id).executeUpdate();
	}

	@Override
	@Transactional
	public void deleteTicketsByIds(List<Long> ticketsIdsList) {
		em.createQuery("DELETE FROM Ticket t WHERE t.id IN :ticketsIdsList").setParameter("ticketsIdsList", ticketsIdsList).executeUpdate();
	}

	@Override
	public Ticket findTicketById(Long id) {
		return (Ticket) Utilities.getSingleResultOrNull(em.createQuery("FROM Ticket t WHERE t.id =:id").setParameter("id", id));
	}

	// TODO tester la fonction
	@Override
	public Ticket findTicketByIdAndFetchUsers(Long id) {
		return (Ticket) Utilities.getSingleResultOrNull(em.createQuery("FROM Ticket t JOIN FETCH t.users WHERE t.id =:id").setParameter("id", id));
	}

	@Override
	public List<Ticket> getTicketsByUser(Long userId) {
		return (List<Ticket>) em.createQuery("SELECT t FROM Ticket t JOIN t.user u WHERE u.id = :userId").setParameter("userId", userId)
				.getResultList();
	}

	public List<Ticket> getTicketsByProjectId(Long projectId) {
		return (List<Ticket>) em.createQuery("FROM Ticket t WHERE t.project.id = :projectId").setParameter("projectId", projectId).getResultList();
	}
}
