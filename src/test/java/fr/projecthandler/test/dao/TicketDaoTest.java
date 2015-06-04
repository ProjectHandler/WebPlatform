package fr.projecthandler.test.dao;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.transaction.TransactionConfiguration;
import org.springframework.transaction.annotation.Transactional;

import fr.projecthandler.dao.TicketDao;
import fr.projecthandler.enums.TicketStatus;
import fr.projecthandler.model.Project;
import fr.projecthandler.model.Ticket;
import fr.projecthandler.model.TicketPriority;
import fr.projecthandler.model.TicketTracker;
import fr.projecthandler.model.User;
import static org.junit.Assert.*;



@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "/spring/test-config.xml"})
@TransactionConfiguration(defaultRollback = true)
public class TicketDaoTest {
	
	@Autowired
	TicketDao ticketDao;

	private String title = "Titre 01";
	private String text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.";
	TicketStatus ticketStatus = TicketStatus.OPEN;
	private User user;
	private Project project;
	private TicketTracker ticketTracker;
	private TicketPriority ticketPriority;
	private List<User> users = new ArrayList<User>();;
    private Date createdAt;
    private Date updatedAt;
    
	private void setTicketData(Ticket ticket) {
		ticket.setTitle(title);
	}
	
	@Test
	@Transactional
	public void testSaveTicket() {
		Ticket ticket = new Ticket();
		
		setTicketData(ticket);		
		ticketDao.saveTicket(ticket);
	}
	
	@Test
	@Transactional
	//Test if the saved fields are equal to the loaded fields.
	public void testSaveAndFindTicketById() {
		Ticket ticket = new Ticket();

		setTicketData(ticket);
		Long id = ticketDao.saveTicket(ticket);
		Ticket result = ticketDao.findTicketById(id);
		assertNotNull("getTicketById: excepted a Ticket Object but was null", result);
		assertEquals(result.getId(), id);
		assertEquals(result.getText(), text);
		assertEquals(result.getTicketStatus(), ticketStatus);
	}
	
	@Test
	@Transactional
	public void testDeleteTicketsByIds() {
		List<Long> ticketIdList = new ArrayList<Long>(); ;
		
		for (int i = 0; i < 10; i++) {
			Ticket ticket = new Ticket();
			setTicketData(ticket);
			ticketIdList.add(ticketDao.saveTicket(ticket));
		}
		
		ticketDao.deleteTicketsByIds(ticketIdList);
		for (Long ticketId : ticketIdList) {
			Ticket result = ticketDao.findTicketById(ticketId);
			assertNull(result);
		}
	}
}
