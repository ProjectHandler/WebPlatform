package fr.projecthandler.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.MailException;
import org.springframework.mail.MailSender;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.stereotype.Service;

@Service
public class MailServiceImpl implements MailService {

	@Autowired
	private MailSender mailSender;
	 
	
	@Override
	public void sendEmail(String from, String to, String subject, String msg) {
		try {
		SimpleMailMessage mailMessage = new SimpleMailMessage();
		mailMessage.setFrom(from);
		mailMessage.setSubject(subject);
		mailMessage.setTo(to);
		mailMessage.setText(msg);
		mailSender.send(mailMessage);
		} catch (MailException e) {
			e.printStackTrace();
		}
	}
	
}
