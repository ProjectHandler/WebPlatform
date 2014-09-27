package fr.projecthandler.service;

import fr.projecthandler.model.User;

public interface UserService {
	
	public Long saveUser(User user);
	
	public User getUserByEmail(String email);

	public User getUserById(Long userId);
	
}
