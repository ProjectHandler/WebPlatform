package fr.projecthandler.service;

import java.util.Locale;
import java.util.ResourceBundle;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.i18n.LocaleContextHolder;
import org.springframework.mail.MailException;
import org.springframework.mail.MailSender;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.stereotype.Service;

import fr.projecthandler.model.User;

@Service
public class MailServiceImpl implements MailService {

	@Autowired
	private MailSender mailSender;

	@Autowired
	private MessageSource messageSource;

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

	@Override
	public void sendEmailUserCreation(User user, String url) { // Locale locale
		Locale locale = Locale.FRANCE;
		/* TODO found method to use local.FRANCE dynamically messageSource.getMessage("selfmed.clientController.retreat", null, locale) */
		// messageSource.getMessage("selfmed.choose", null, LocaleContextHolder.getLocale());
		
		ResourceBundle bundle = ResourceBundle.getBundle("messages/messages", locale);
		String subject = bundle.getString("projecthandler.mail.subject.signup");
		String msg = bundle.getString("projecthandler.mail.content.signup");
		SimpleMailMessage mailMessage = new SimpleMailMessage();
		StringBuilder msg_url = new StringBuilder();
		msg_url.append(msg);
		msg_url.append(url);
		mailMessage.setText(msg_url.toString());
		mailMessage.setSubject(subject);
		mailMessage.setTo(user.getEmail());
		mailSender.send(mailMessage);
	}
	
	@Override
	public void sendEmailRestPassword(User user, String url) {
		Locale locale = Locale.FRANCE;
		
		ResourceBundle bundle = ResourceBundle.getBundle("messages/messages", locale);
		String subject = bundle.getString("projecthandler.mail.subject.forgotPassword");
		String msg = bundle.getString("projecthandler.mail.content.forgotPassword");
		SimpleMailMessage mailMessage = new SimpleMailMessage();
		StringBuilder msg_url = new StringBuilder();
		msg_url.append(msg);
		msg_url.append(url);
		mailMessage.setText(msg_url.toString());
		mailMessage.setSubject(subject);
		mailMessage.setTo(user.getEmail());
		mailSender.send(mailMessage);
	}

}
