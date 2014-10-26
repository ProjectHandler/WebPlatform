package fr.projecthandler.dao;

import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import fr.projecthandler.model.Token;
import fr.projecthandler.util.Utilities;

@Component
public class TokenDaoImpl extends AbstractDao implements TokenDao {

	@Override
	@Transactional
	public Long saveToken(Token token) {
		em.persist(token);
		return token.getId();
	}


	@Override
	public Token findTokenByUserId(Long userId) {
		return (Token) Utilities.getSingleResultOrNull( em.createQuery("SELECT t FROM Token t WHERE t.user.id = :userId")
				.setParameter("userId", userId));
	}

	@Override
	@Transactional
	public void deleteTokenByUserId(Long userId) {
		em.createQuery("DELETE FROM Token t WHERE t.user.id = :userId")
		.setParameter("userId", userId).executeUpdate();
	}

}
