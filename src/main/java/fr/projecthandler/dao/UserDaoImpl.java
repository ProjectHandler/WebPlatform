package fr.projecthandler.dao;

import java.util.List;

import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import fr.projecthandler.Util.Utilities;
import fr.projecthandler.model.User;

@Component
public class UserDaoImpl extends AbstractDao implements UserDao {

	@Override
	public User findUserById(Long userId) {
		return (User) Utilities.getSingleResultOrNull(
				em.createQuery("SELECT u FROM Users u WHERE u.id = :userId")
				.setParameter("userId", userId)
				);
	}

	@Override
	@Transactional
	public void updateUser(User user) {
		em.merge(user);
	}

	@Override
	@Transactional
	public Long saveUser(User user) {
		em.persist(user);
		return user.getId();
	}

	@Override
	public User findByEmail(String email) {
		return (User)em.createQuery("SELECT u FROM User u WHERE u.email = :email")
				.setParameter("email", email).getSingleResult();
	}

	@Override
	public List<User> getAllUsers() {
		return (List<User>)em.createQuery("SELECT u FROM User u").getResultList();
	}

	@Override
	@Transactional
	public void deleteUserByListIds(List<Long> usersIdsList) {
		em.createQuery("DELETE FROM User u WHERE u.id IN (:usersIdsList)")
		.setParameter("usersIdsList", usersIdsList).executeUpdate();
	}

}
