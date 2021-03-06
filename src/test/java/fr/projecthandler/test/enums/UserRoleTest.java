package fr.projecthandler.test.enums;

import org.junit.Test;

import static org.junit.Assert.*;
import fr.projecthandler.enums.UserRole;

public class UserRoleTest {
	
	@Test
	public void testGetId() {
		UserRole role = UserRole.ROLE_ADMIN;
		
		role = UserRole.ROLE_ADMIN;
		assertEquals((Integer)0, role.getId());
		role = UserRole.ROLE_SIMPLE_USER;
		assertEquals((Integer)1, role.getId());
	}
	
	@Test
	public void testFind() {
		assertEquals(UserRole.ROLE_ADMIN, UserRole.find(0));
		assertEquals(UserRole.ROLE_SIMPLE_USER, UserRole.find(1));
	}
}
