package fr.projecthandler.dao;

import java.util.List;

import fr.projecthandler.model.User;

public interface UserDao {

	public Long saveUser(User user);

	public void updateUser(User user);

	public void deleteUsersByIds(List<Long> users);

	public User findUserById(Long userId);

	public User findByEmail(String email);

	public List<User> getAllUsers();

	public User findUserByIdAndFetchProjects(Long userId);

}