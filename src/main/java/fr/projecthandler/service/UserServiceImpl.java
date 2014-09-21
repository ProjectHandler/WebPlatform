package fr.projecthandler.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import fr.projecthandler.dao.UserDao;
import fr.projecthandler.model.User;

@Service
public class UserServiceImpl implements UserService {

	@Autowired
	UserDao userDao;
	
	@Override
	public Long saveUser(User user) {
		return userDao.saveUser(user);
	}

	@Override
	public User getUserByEmail(String email) {
		return userDao.findByEmail(email);
	}
	
}
