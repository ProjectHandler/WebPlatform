package fr.projecthandler.test.api;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.transaction.TransactionConfiguration;
import org.springframework.test.context.web.WebAppConfiguration;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.context.WebApplicationContext;

import java.lang.reflect.Type;
import java.text.DateFormat;
import java.text.SimpleDateFormat;

import com.fasterxml.jackson.databind.ObjectMapper;

import fr.projecthandler.dao.ProjectDao;
import fr.projecthandler.model.Project;
import fr.projecthandler.test.content.DataProvider;
import fr.projecthandler.test.util.TestUtil;

import static org.hamcrest.Matchers.*;
import static org.junit.Assert.assertEquals;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "/spring/test-config.xml", "/spring/spring-security.xml", "/spring/mvc-core-config.xml" })
@TransactionConfiguration(defaultRollback = true)
@WebAppConfiguration
public class ProjectRestControllerTest {
	private MockMvc mockMvc;

	@Autowired
	private WebApplicationContext wac;

	@Autowired
	ProjectDao projectDao;

	@Before
	public void setup() {
		this.mockMvc = MockMvcBuilders.webAppContextSetup(this.wac).build();
	}

	@Test
	@Transactional
	public void getTest() throws Exception {
		Project project = DataProvider.getProject1Data();
		DateFormat dateFormat = new SimpleDateFormat("MMM d, yyyy h:mm:ss a");
		Long id = projectDao.saveProject(project);
		ObjectMapper mapper = new ObjectMapper();

		MvcResult result = mockMvc.perform(get("/api/project/get/{id}?token={token}", id, TestUtil.API_TOKEN))
		.andExpect(status().isOk())
		.andExpect(content().contentType(TestUtil.APPLICATION_JSON_UTF8))
		.andReturn()
		;

		String content = result.getResponse().getContentAsString();
		mapper.setDateFormat(dateFormat);
		Project resultProject = mapper.readValue(content, Project.class);
		assertEquals(project.getName(), resultProject.getName());
		assertEquals(dateFormat.format(project.getDateBegin()), dateFormat.format(resultProject.getDateBegin()));
		assertEquals(dateFormat.format(project.getDateEnd()), dateFormat.format(resultProject.getDateEnd()));
		assertEquals(project.getDuration(), resultProject.getDuration());
		assertEquals(project.getDescription(), resultProject.getDescription());
		assertEquals(project.getProgress(), resultProject.getProgress());
		assertEquals(project.getStatus(), resultProject.getStatus());		
	}

	//TODO Compléter le test
//	@Test
//	public void getEventsByUserTest() throws Exception {
//		mockMvc.perform(get("/api/project/allByCurrentUser?token={token}", 1L, TestUtil.API_TOKEN))
//		.andExpect(status().isOk())
//		.andExpect(content().contentType(TestUtil.APPLICATION_JSON_UTF8))
//		;
//	}

}
