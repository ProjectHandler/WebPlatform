package fr.projecthandler.service;

import fr.projecthandler.model.User;

public interface MailService {

	public void sendEmail(String from, String to, String subject, String message);

	public void sendEmailUserCreation(User user, String url);
	
	public void sendEmailRestPassword(User user, String url);
	
}
