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
	public void save(Ticket ticket) {
		em.persist(ticket);
	}

	@Override
	public Ticket findTicketById(Long id) {
		return (Ticket) Utilities.getSingleResultOrNull(
				em.createQuery("FROM Ticket t WHERE t.id =:id").setParameter("id", id));
	}

	@Override
	public List<Ticket> getTicketByUser(Long userId) {
		return (List<Ticket>)em.createQuery("FROM Ticket t WHERE t.user.id = :userId")
				.setParameter("userId", userId)
				.getResultList();
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
	public void deleteTicketByListIds(List<Long> ticketsIdsList) {
		em.createQuery("DELETE FROM Ticket t WHERE t.id IN :ticketsIdsList")
		.setParameter("ticketsIdsList", ticketsIdsList).executeUpdate();
	}
	
	public List<Ticket> findTicketsByProjectId(Long projectId) {
		return (List<Ticket>)em.createQuery("FROM Ticket t WHERE t.project.id = :projectId")
				.setParameter("projectId", projectId)
				.getResultList();
	}
}
