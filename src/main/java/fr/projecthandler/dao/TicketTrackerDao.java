package fr.projecthandler.dao;

import java.util.List;

import fr.projecthandler.model.TicketTracker;

public interface TicketTrackerDao {
	
	public Long saveTicketTracker(TicketTracker ticketTracker);

	public void updateTicketTracker(TicketTracker ticketTracker);

	public void deleteTicketTrackerById(Long ticketTrackerId);

	public void deleteTicketTrackersByIds(List<Long> ticketTrackers);

	public TicketTracker findTicketTrackerById(Long ticketTrackerId);

	public List<TicketTracker> getTicketTrackersByTicketId(Long ticketId);

	public List<TicketTracker> getAllTicketTrackers();
}