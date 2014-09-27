package fr.projecthandler.dao;

import java.util.List;

import fr.projecthandler.model.User;

public interface UserDao {

	public User findUserById(Long userId);

	public void updateUser(User user);

	public Long saveUser(User user);

	public User findByEmail(String email);

	public List<User> getAllUsers();
	
	public void deleteUserByListIds(List<Long> users);
}
