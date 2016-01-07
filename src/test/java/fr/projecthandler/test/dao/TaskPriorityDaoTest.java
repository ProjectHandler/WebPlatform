package fr.projecthandler.test.dao;

import static org.junit.Assert.assertEquals;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.transaction.TransactionConfiguration;
import org.springframework.transaction.annotation.Transactional;

import fr.projecthandler.dao.TaskPriorityDao;
import fr.projecthandler.model.TaskPriority;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "/spring/test-config.xml"})
@TransactionConfiguration(defaultRollback = true)
public class TaskPriorityDaoTest {
	@Autowired
	TaskPriorityDao taskPriorityDao;
	
	@Test
	@Transactional
	public void findTaskPriorityById() {
		TaskPriority tp = taskPriorityDao.findTaskPriorityById(1l);
		
		assertEquals("MEDIUM", tp.getName());
		assertEquals(20, tp.getValue());
		
		tp = taskPriorityDao.findTaskPriorityById(2l);
		
		assertEquals("HIGH", tp.getName());
		assertEquals(30, tp.getValue());

		tp = taskPriorityDao.findTaskPriorityById(4l);
		
		assertEquals("LOW", tp.getName());
		assertEquals(10, tp.getValue());
	}

	@Test
	@Transactional
	public void getAllTaskPriorities() {
		List<TaskPriority> tpList = taskPriorityDao.getAllTaskPriorities();
		
		assertEquals(3, tpList.size());
	}
}
