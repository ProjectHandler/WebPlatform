package fr.projecthandler.service;

import fr.projecthandler.model.Token;
import fr.projecthandler.model.User;

public interface TokenService {
	public Long saveToken(Token token);

	public Token findTokenByUserId(Long userId);

	public void deleteTokenByUserId(Long id);
	
	public User findUserByToken(String token);
}
