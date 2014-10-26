package fr.projecthandler.dao;

import fr.projecthandler.model.Token;

public interface TokenDao {
	public Long saveToken(Token token);
	
	public Token findTokenByUserId(Long userId);
	
	public void deleteTokenByUserId(Long id);
}
