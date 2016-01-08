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

import com.google.common.reflect.TypeToken;
import com.google.gson.Gson;

import fr.projecthandler.dao.EventDao;
import fr.projecthandler.dao.TokenDao;
import fr.projecthandler.model.Event;
import fr.projecthandler.test.content.DataProvider;
import fr.projecthandler.test.util.TestUtil;

import static org.hamcrest.Matchers.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

import java.util.Date;
import java.util.List;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "/spring/test-config.xml", "/spring/spring-security.xml", "/spring/mvc-core-config.xml" })
@TransactionConfiguration(defaultRollback = true)
@WebAppConfiguration
public class EventRestControllerTest {
	private MockMvc mockMvc;

	@Autowired
	private WebApplicationContext wac;

	@Autowired
	EventDao eventDao;
	
	@Before
	public void setup() {
		this.mockMvc = MockMvcBuilders.webAppContextSetup(this.wac).build();
	}

	@Test
	@Transactional
	public void getTest() throws Exception {
		Event event = DataProvider.getEventData();
		Long id = eventDao.saveEvent(event);

		mockMvc.perform(get("/api/event/get/{id}?token={token}", id, TestUtil.API_TOKEN))
		.andExpect(status().isOk())
		.andExpect(content().contentType(TestUtil.APPLICATION_JSON_UTF8))
		.andExpect(jsonPath("$.title", is(event.getTitle())))
		.andExpect(jsonPath("$.description", is(event.getDescription())))
		.andExpect(jsonPath("$.startingDate", is(event.getStartingDate().getTime()))) //2015-10-13 13:00:00
		.andExpect(jsonPath("$.endingDate", is(event.getEndingDate().getTime()))) //2015-10-13 15:00:00
		.andExpect(jsonPath("$.status", is(event.getStatus())))
		;
	}

	//TODO Compléter le test
	@Test
	public void getEventsByUserTest() throws Exception {
		mockMvc.perform(get("/api/event/getEventsByUser/{id}?token={token}", 1L, TestUtil.API_TOKEN))
		.andExpect(status().isOk())
		.andExpect(content().contentType(TestUtil.APPLICATION_JSON_UTF8))
		;
		
//		String content = result.getResponse().getContentAsString();
//		Gson gson = new Gson();
//		Type type = new TypeToken<List<Event>>() {}.getType();
//		
//		List<Event> eventList = gson.fromJson(content, type);
//		System.out.println(eventList.get(0).getTitle());
	}

}
