package fr.projecthandler.formatter;

import java.text.ParseException;
import java.util.Locale;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.Formatter;
import org.springframework.stereotype.Component;

import fr.projecthandler.model.TicketTracker;
import fr.projecthandler.service.TicketService;

@Component
public class TicketTrackerFormatter implements Formatter<TicketTracker> {

	@Autowired
	private TicketService ticketService;

	@Override
	public String print(TicketTracker project, Locale locale) {
		return project.getId().toString();
	}

	@Override
	public TicketTracker parse(String projectId, Locale locale) throws ParseException {
		return ticketService.findTicketTrackerById(Long.parseLong(projectId));
	}
}
