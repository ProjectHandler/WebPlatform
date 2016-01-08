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
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.context.WebApplicationContext;

import com.google.gson.Gson;

import fr.projecthandler.dao.TokenDao;
import fr.projecthandler.dao.UserDao;
import fr.projecthandler.dto.UserDTO;
import fr.projecthandler.model.Token;
import fr.projecthandler.model.User;
import fr.projecthandler.test.content.DataProvider;
import fr.projecthandler.test.util.TestUtil;
import io.swagger.annotations.ApiParam;

import static org.hamcrest.Matchers.*;
import static org.hamcrest.Matchers.hasSize;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;

import java.nio.charset.StandardCharsets;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "/spring/test-config.xml", "/spring/spring-security.xml", "/spring/mvc-core-config.xml" })
@TransactionConfiguration(defaultRollback = true)
@WebAppConfiguration
public class UserRestControllerTest {
	private MockMvc mockMvc;

	@Autowired
	private WebApplicationContext wac;

	@Autowired
	TokenDao tokenDao;
	
	@Before
	public void setup() {
		this.mockMvc = MockMvcBuilders.webAppContextSetup(this.wac).build();
	}

	@Test
	public void authenticateTest() throws Exception {
		mockMvc.perform(get("/api/user/authenticate?email={email}&password={password}", "admin@admin.com", "Admin"))
		.andExpect(status().isOk())
		.andExpect(content().contentType(TestUtil.APPLICATION_JSON_UTF8))
		.andExpect(jsonPath("$.token", is(notNullValue())))
		;
	}

	@Test
	public void getTest() throws Exception {
		mockMvc.perform(get("/api/user/get/{userId}?token={token}", 1L, TestUtil.API_TOKEN))
		.andExpect(status().isOk())
		.andExpect(content().contentType(TestUtil.APPLICATION_JSON_UTF8))
		.andExpect(jsonPath("$.id", is(1)))
		.andExpect(jsonPath("$.firstName", is("Admin")))
		.andExpect(jsonPath("$.lastName", is("Admin")))
		.andExpect(jsonPath("$.email", is("admin@admin.com")))
		.andExpect(jsonPath("$.phone", is("0123456789")))
		.andExpect(jsonPath("$.mobilePhone", is("")))
		;	
	}
	
	@Test
	public void getTestNoFound() throws Exception {
		mockMvc.perform(get("/api/user/get/{userId}?token={token}", 19009283110L, TestUtil.API_TOKEN))
		.andExpect(status().isNotFound())
		.andExpect(content().contentType(TestUtil.APPLICATION_JSON_UTF8))
		;	
	}

// TODO Corriger le problème de configuration des tests: pas de vérification du token
//	@Test
//	public void getTestNotAuthenticated() throws Exception {
//		mockMvc.perform(get("/api/user/get/{userId}", 1L))
//		.andExpect(status().isForbidden())
//		.andExpect(content().contentType(TestUtil.APPLICATION_JSON_UTF8))
//		;
//	}
	
	@Test
	public void createTest() throws Exception {
		UserDTO userDTO = new UserDTO(DataProvider.getUser1Data());
		Gson gson = new Gson();

        mockMvc.perform(post("/api/user/save?token={token}", 19009283110L, TestUtil.API_TOKEN)
                .contentType(TestUtil.APPLICATION_JSON_UTF8)
                .content(gson.toJson(userDTO).getBytes(StandardCharsets.UTF_8)))
        .andExpect(status().isCreated())
        ;
	}
}
