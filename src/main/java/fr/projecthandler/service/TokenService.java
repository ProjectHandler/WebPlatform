package fr.projecthandler.service;

import fr.projecthandler.model.Token;

public interface TokenService {
	public Long saveToken(Token token);

	public Token findTokenByUserId(Long userId);

	public void deleteTokenByUserId(Long id);
}
