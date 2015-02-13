package fr.projecthandler.test.enums;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import static org.junit.Assert.*;
import fr.projecthandler.enums.Civility;

public class CivilityTest {
	
	@Test
	public void testGet() {
		Civility role = Civility.M;
		
		role = Civility.M;
		assertEquals((Integer)0, role.getId());
		assertEquals("M.", role.getValue());
		role = Civility.MME;
		assertEquals((Integer)1, role.getId());
		assertEquals("Mme.", role.getValue());
	}
	
	@Test
	public void testFindCivilityById () {
		assertEquals(Civility.M, Civility.findCivilityById(0));
		assertEquals(Civility.MME, Civility.findCivilityById(1));
	}
}
