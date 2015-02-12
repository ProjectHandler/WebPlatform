package fr.projecthandler.test.util;

import org.junit.Test;

import static org.junit.Assert.*;
import fr.projecthandler.util.TokenGenerator;

import com.jcabi.matchers.RegexMatchers;

public class TokenGeneratorTest {
	
	@Test
	//Checks if the format of the returned token is valid
	public void testGenerateToken() {
		String token;

		for (Integer i = 0; i < 1000; i++) {
			token = TokenGenerator.generateToken();
			assertThat(token, RegexMatchers.matchesPattern("[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}"));
		}
	}
	
	@Test(timeout=10)
	//Checks if checkTimestamp() returns true when the token is out of date and false otherwise.
	//Since the test and checkTimestamp use the current time, the test has to run fast in order to be accurate.
	public void testCheckTimestamp() {
		java.util.Date currentDate = new java.util.Date();
		
		assertFalse(TokenGenerator.checkTimestamp(16545235L, currentDate.getTime() - 16541235L));
		assertFalse(TokenGenerator.checkTimestamp(11L, currentDate.getTime() - 0L));
		assertTrue(TokenGenerator.checkTimestamp(88945347897124456L, currentDate.getTime() - 98945347897124456L));
		assertTrue(TokenGenerator.checkTimestamp(654L, currentDate.getTime() - 4134L));
		assertTrue(TokenGenerator.checkTimestamp(124L, currentDate.getTime() - 125L));
	}
}
