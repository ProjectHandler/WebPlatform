package fr.projecthandler.formatter;

import java.text.ParseException;
import java.util.Locale;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.Formatter;
import org.springframework.stereotype.Component;

import fr.projecthandler.model.TicketPriority;
import fr.projecthandler.service.TicketService;

@Component
public class TicketPriorityFormatter implements Formatter<TicketPriority> {

	@Autowired
	private TicketService ticketService;

	@Override
	public String print(TicketPriority project, Locale locale) {
		return project.getId().toString();
	}

	@Override
	public TicketPriority parse(String projectId, Locale locale) throws ParseException {
		return ticketService.findTicketPriorityById(Long.parseLong(projectId));
	}
}
