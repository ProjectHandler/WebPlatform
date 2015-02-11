import org.junit.Test;
import static org.junit.Assert.*;
import fr.projecthandler.enums.UserRole;

public class UserRoleTest {
	
	//test useless
	@Test
	public void testGetId() {
		UserRole role = UserRole.ROLE_ADMIN;
		
		role = UserRole.ROLE_ADMIN;
		assertEquals((Integer)0, role.getId());
		role = UserRole.ROLE_PROJECT_CHIEF;
		assertEquals((Integer)1, role.getId());
		role = UserRole.ROLE_MANAGER;
		assertEquals((Integer)2, role.getId());
		role = UserRole.ROLE_SIMPLE_USER;
		assertEquals((Integer)3, role.getId());
	}
}
