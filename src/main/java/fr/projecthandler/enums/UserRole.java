package fr.projecthandler.enums;

import java.io.Serializable;

public enum UserRole implements Serializable {

	ROLE_ADMIN(0), ROLE_PROJECT_CHIEF(1), ROLE_MANAGER(2), ROLE_SIMPLE_USER(3);

	private Integer id;

	private UserRole(Integer id) {
		this.setId(id);
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public static UserRole find(Integer code) {
		if (code != null) {
			for (UserRole userRole : UserRole.values()) {
				if (code.equals(userRole.getId())) {
					return userRole;
				}
			}
		}
		return null;
	}

}