package fr.projecthandler.service;

public interface MailService {
	
	public void sendEmail(String from, String to, String subject, String message); 
}
