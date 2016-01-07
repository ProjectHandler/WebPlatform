package fr.projecthandler.test.dao;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.transaction.TransactionConfiguration;
import org.springframework.transaction.annotation.Transactional;
import static org.junit.Assert.*;

import java.util.List;

import fr.projecthandler.dao.CivilityDao;
import fr.projecthandler.model.Civility;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "/spring/test-config.xml"})
@TransactionConfiguration(defaultRollback = true)
public class CivilityDaoTest {

	@Autowired
	CivilityDao civilityDao;
	
	@Test
	@Transactional
	public void testFindCivilityById() {
		assertEquals(civilityDao.findCivilityById(1l).getName(), "projecthandler.civility.mister");
		assertEquals(civilityDao.findCivilityById(2l).getName(), "projecthandler.civility.mrs");
		assertEquals(civilityDao.findCivilityById(3l).getName(), "projecthandler.civility.miss");
	}

	@Test
	@Transactional
	public void testGetAllCivilities() {
		List<Civility> civilities = civilityDao.getAllCivilities();
			assertEquals(civilities.get(0).getId(), new Long(1));
			assertEquals(civilities.get(0).getName(), "projecthandler.civility.mister");
			assertEquals(civilities.get(1).getId(), new Long(2));
			assertEquals(civilities.get(1).getName(), "projecthandler.civility.mrs");
			assertEquals(civilities.get(2).getId(), new Long(3));
			assertEquals(civilities.get(2).getName(), "projecthandler.civility.miss");
	}
}
