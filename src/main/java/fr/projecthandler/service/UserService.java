package fr.projecthandler.service;

import java.util.List;

import fr.projecthandler.model.User;

public interface UserService {

	public Long saveUser(User user);

	public void updateUser(User user);
	
	public User getUserByEmail(String email);

	public User findUserById(Long userId);

	public void deleteUserByIds(List<Long> usersList);

	public List<User> getAllUsers();
}