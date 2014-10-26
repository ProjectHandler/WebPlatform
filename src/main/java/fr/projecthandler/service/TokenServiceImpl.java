package fr.projecthandler.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import fr.projecthandler.dao.TokenDao;
import fr.projecthandler.model.Token;

@Service	
public class TokenServiceImpl implements TokenService {

	@Autowired
	TokenDao tokenDao;
	
	@Override
	public Long saveToken(Token token) {
		return tokenDao.saveToken(token);
	}

	@Override
	public Token findTokenByUserId(Long userId) {
		return tokenDao.findTokenByUserId(userId);
	}

	@Override
	public void deleteTokenByUserId(Long userId) {
		tokenDao.deleteTokenByUserId(userId);
	}

}
