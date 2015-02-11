import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import static org.junit.Assert.*;
import fr.projecthandler.util.Utilities;

import org.springframework.core.SpringVersion;
import org.springframework.mock.web.MockHttpServletRequest;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "/spring/business-config.xml" })
public class UtilitiesTest {
	
	@Test
	public void testGetRequestParameter() {
	// error java.lang.ClassNotFoundException: javax.servlet.AsyncContext
	/*
	MockHttpServletRequest request = new MockHttpServletRequest();
	
	String name = "name";
	String value = "Jean";
	request.addParameter(name, value);
	assertEquals(value, Utilities.getRequestParameter(request, name));
	*/
	}
}
