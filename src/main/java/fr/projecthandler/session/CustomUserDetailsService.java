package fr.projecthandler.session;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import fr.projecthandler.dao.UserDao;
import fr.projecthandler.enums.AccountStatus;
import fr.projecthandler.model.User;

@Service
@Transactional(readOnly = true)
public class CustomUserDetailsService implements UserDetailsService {

	private static final Log log = LogFactory.getLog(CustomUserDetailsService.class);
	
	@Autowired
	UserDao userDao;

	@Override
	@Transactional(noRollbackFor = UsernameNotFoundException.class)
	public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
		User user = null;
		try {
			user = userDao.findByEmail(email);
		} catch (Exception e) {
			log.error("error user name not found exception", e);
			throw new UsernameNotFoundException("The email " + email + " was not found!", e);
		}
		if (user == null) {
			throw new UsernameNotFoundException("The email " + email + " was not found!");
		}
		boolean enabled = user.getAccountStatus() == AccountStatus.ACTIVE ? true : false;
		boolean accountNonExpired = true;
		boolean credentialsNonExpired = true;
		boolean accountNonLocked = true;

		CustomUserDetails userDetails = new CustomUserDetails(user.getId(), user.getEmail(), user.getPassword(), enabled, accountNonExpired,
				credentialsNonExpired, accountNonLocked, getAuthorities(user), user.getFirstName(), user.getLastName(), user.getAccountStatus(),
				user.getUserRole(), user.getAvatarFileName(), user.getLocale());

		return userDetails;
	}

	public Collection<? extends GrantedAuthority> getAuthorities(User user) {
		List<GrantedAuthority> authList = getGrantedAuthorities(getRoles(user));
		return authList;
	}

	public List<String> getRoles(User user) {
		List<String> roles = new ArrayList<String>();
		roles.add(user.getUserRole().name());
		roles.add(user.getAccountStatus().name());
		return roles;
	}

	public static List<GrantedAuthority> getGrantedAuthorities(List<String> roles) {
		List<GrantedAuthority> authorities = new ArrayList<GrantedAuthority>();
		for (String role : roles) {
			authorities.add(new SimpleGrantedAuthority(role));
		}
		return authorities;
	}
}