package fr.projecthandler.test.util;

import org.junit.Test;
import org.junit.runner.RunWith;

import static org.junit.Assert.*;
import fr.projecthandler.util.EmailValidator;

import com.tngtech.java.junit.dataprovider.DataProvider;
import com.tngtech.java.junit.dataprovider.DataProviderRunner;
import com.tngtech.java.junit.dataprovider.UseDataProvider;

@RunWith(DataProviderRunner.class)
public class EmailValidatorTest {
	
	private EmailValidator emailValidator = new EmailValidator();
	
	@DataProvider
	public static Object[][] emailProvider() {
		return new Object[][] {
				{ "martin@hotmail.com", true },
				{ "jean.hubertATcaramail.com", false },
				{ "me@example.com", true },
				{ "a.nonymous@example.com", true },
				{ "name+tag@example.com", true },
				{ "a.name+tag@example.com", true },
				{ "me.example@com", false }, //false, but should be valid according to RFC2822
				{ "\"spaces must be quoted\"@example.com", false }, //false, but should be valid according to RFC2822
				{ "!#$%&'*+-/=.?^_`{|}~@[1.0.0.127]", false }, //false, but should be valid according to RFC2822
				{ "!#$%&'*+-/=.?^_`{|}~@[IPv6:0123:4567:89AB:CDEF:0123:4567:89AB:CDEF]", false },  //false, but should be valid according to RFC2822
				{ "me(this is a comment)@example.com", false },  //false, but should be valid according to RFC2822
				{ "me@", false },
				{ "@example.com", false },
				{ "me.@example.com", false },
				{ ".me@example.com", false },
				{ "me@example..com", false },
				{ "me\\@example.com", false },
				{ "spaces\\ must\\ be\\ within\\ quotes\\ even\\ when\\ escaped@example.com", false },
				{ "a\\@mustbeinquotes@example.com", false },

        };
    }

	@Test
	@UseDataProvider("emailProvider")
	public void testValidate(final String input, final boolean output) {
		assertEquals("email \"" + input + "\"", output, emailValidator.validate(input));
	}
}
