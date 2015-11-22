package fr.projecthandler.service;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import fr.projecthandler.dao.TokenDao;
import fr.projecthandler.enums.AccountStatus;
import fr.projecthandler.model.Token;
import fr.projecthandler.model.User;

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

	@Override
	public User findUserByToken(String token) {
		return tokenDao.findUserByToken(token);
	}

	public String buildTokenUrl(HttpServletRequest request, User user, Token token) {
		if (!user.getAccountStatus().equals(AccountStatus.INACTIVE)) {
			return "redirect:/accessDenied";
		}
		StringBuilder url = new StringBuilder();
		String serverName = request.getServerName();
		url.append(request.getScheme()).append("://").append(serverName);

		int serverPort = request.getServerPort();
		if ((serverPort != 80) && (serverPort != 443)) {
			url.append(":").append(serverPort);
		}
		url.append(request.getContextPath()).append("/verifyUser?token=" + token.getToken());
		return url.toString();
	}
}
