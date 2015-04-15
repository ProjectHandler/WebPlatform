package fr.projecthandler.test.util;

import org.junit.Test;
import org.springframework.security.crypto.bcrypt.BCrypt;
import static org.junit.Assert.*;

public class GeneratePasswordTest {
	
	@Test
	public void testGeneratePassword() {	
		String encodedPassword = BCrypt.hashpw("toto", "$2a$10$a5Fte4I8lIB3MKB8LofZBu");
		assertEquals("$2a$10$a5Fte4I8lIB3MKB8LofZBuZGXUiB3qJVb6orvvw/lR2Y38GADq.6O", encodedPassword);
		encodedPassword = BCrypt.hashpw("kPo?p45fe_", "$2a$10$4xQ1TUOH3bX7WmyNWXsxOe");
		assertEquals("$2a$10$4xQ1TUOH3bX7WmyNWXsxOe3qTgY5KtnPOjxB.jb3Aq2TZ/i6LcYMG", encodedPassword);
	}
}
