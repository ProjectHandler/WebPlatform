package fr.projecthandler.dao;

import java.util.List;

import javax.persistence.Query;

import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

import fr.projecthandler.enums.AccountStatus;
import fr.projecthandler.enums.UserRole;
import fr.projecthandler.model.User;
import fr.projecthandler.util.Utilities;

@Component
public class UserDaoImpl extends AbstractDao implements UserDao {

	@Override
	@Transactional
	public Long saveUser(User user) {
		em.persist(user);
		return user.getId();
	}

	@Override
	@Transactional
	public void updateUser(User user) {
		em.merge(user);
	}

	@Override
	@Transactional
	public void deleteUsersByIds(List<Long> usersIdsList) {
		em.createQuery("DELETE FROM User u WHERE u.id IN (:usersIdsList)").setParameter("usersIdsList", usersIdsList).executeUpdate();
	}

	@Override
	public User findUserById(Long userId) {
		return (User) Utilities.getSingleResultOrNull(em.createQuery("Select u from User u where u.id = :userId").setParameter("userId", userId));
	}

	@Override
	public User findByEmail(String email) {
		return (User) Utilities.getSingleResultOrNull(em.createQuery("SELECT u FROM User u WHERE u.email = :email").setParameter("email", email));
	}

	@Override
	public List<User> getAllUsers() {
		return (List<User>) em.createQuery("SELECT u FROM User u").getResultList();
	}

	@Override
	public List<User> getAllUsersWithGroups() {
		return (List<User>) em.createQuery("SELECT DISTINCT u FROM User u LEFT JOIN FETCH u.groups").getResultList();
	}
	
	@Override
	public List<User> getAllActiveUsers() {
		return (List<User>) em.createQuery("SELECT u FROM User u WHERE u.accountStatus = 1").getResultList();
	}

	@Override
	public List<User> getUsersByRole(UserRole userRole) {
		return (List<User>) em.createQuery("SELECT u FROM User u WHERE u.userRole = :userRole").setParameter("userRole", userRole).getResultList();
	}

	// TODO Ca devrait pas etre left join fetch ?
	@Override
	public User findUserByIdAndFetchProjects(Long userId) {
		Query query = em.createQuery("Select u from User u JOIN FETCH u.projects WHERE u.id = :userId").setParameter("userId", userId);

		return Utilities.getSingleResultOrNullWithoutSettingMaxResults(query);
	}

	//TODO renomme la fonction, c'est pas vraiment les "active"
	public List<User> getAllActiveUsersInProject(Long projectId) {
		return (List<User>) em.createQuery("SELECT u FROM User u JOIN FETCH u.projects ps WHERE ps.id = :projectId AND u.accountStatus != :statusInactive")
				.setParameter("projectId", projectId)
				.setParameter("statusInactive", AccountStatus.INACTIVE)
				.getResultList();
	}
}