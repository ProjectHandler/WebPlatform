package fr.projecthandler.dao;

import org.springframework.context.ApplicationListener;
import org.springframework.security.authentication.event.InteractiveAuthenticationSuccessEvent;
import org.springframework.stereotype.Component;


@Component
public class LoginListener implements ApplicationListener<InteractiveAuthenticationSuccessEvent> {

	@Override
	public void onApplicationEvent(InteractiveAuthenticationSuccessEvent event) {
	}

}
