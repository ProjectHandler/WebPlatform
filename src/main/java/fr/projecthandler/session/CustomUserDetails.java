package fr.projecthandler.session;

import java.util.Collection;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import fr.projecthandler.enums.AccountStatus;
import fr.projecthandler.enums.UserRole;

public class CustomUserDetails implements UserDetails {

	private static final long serialVersionUID = 1354773215595633736L;

	private Long id;
	private Collection<? extends GrantedAuthority> authorities;
	private String password;
	private String firstName;
	private String lastName;
	private String avatarFileName;
	private String username;
	// private String fullname;
	private boolean accountNonExpired;
	private boolean accountNonLocked;
	private boolean credentialsNonExpired;
	private boolean enabled;
	private AccountStatus accountStatus;
	private UserRole userRole;

	public CustomUserDetails(Long id, String username, String password, boolean enabled, boolean accountNonExpired, boolean credentialsNonExpired,
			boolean accountNonLocked, Collection<? extends GrantedAuthority> authorities, String firstName, String lastName,
			AccountStatus accountStatus, UserRole userRole, String avatarFileName) {
		this.id = id;
		this.authorities = authorities;
		this.accountNonExpired = accountNonExpired;
		this.accountNonLocked = accountNonLocked;
		this.credentialsNonExpired = credentialsNonExpired;
		this.enabled = enabled;
		this.password = password;
		this.firstName = firstName;
		this.lastName = lastName;
		this.avatarFileName = avatarFileName;
		this.username = username;
		this.accountStatus = accountStatus;
		this.setUserRole(userRole);
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	@Override
	public Collection<? extends GrantedAuthority> getAuthorities() {
		return authorities;
	}

	@Override
	public String getPassword() {
		return password;
	}

	@Override
	public String getUsername() {
		return username;
	}

	@Override
	public boolean isAccountNonExpired() {
		return accountNonExpired;
	}

	public String getFirstName() {
		return firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public String getAvatarFileName() {
		return avatarFileName;
	}

	@Override
	public boolean isAccountNonLocked() {
		return accountNonLocked;
	}

	@Override
	public boolean isCredentialsNonExpired() {
		return credentialsNonExpired;
	}

	@Override
	public boolean isEnabled() {
		return enabled;
	}

	public AccountStatus getAccountStatus() {
		return accountStatus;
	}

	public void setAccountStatus(AccountStatus accountStatus) {
		this.accountStatus = accountStatus;
	}

	public UserRole getUserRole() {
		return userRole;
	}

	public void setUserRole(UserRole userRole) {
		this.userRole = userRole;
	}

}
