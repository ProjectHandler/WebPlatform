package fr.projecthandler.web;
import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.jdbc.datasource.init.ResourceDatabasePopulator;
import org.springframework.jdbc.datasource.init.ScriptException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import fr.projecthandler.annotation.CurrentUserDetails;
import fr.projecthandler.enums.UserRole;
import fr.projecthandler.service.ApplicationSettingsService;
import fr.projecthandler.session.CustomUserDetails;

@Controller
@RequestMapping("debug")
public class DebugController {

	private static final Log log = LogFactory.getLog(DebugController.class);

	@Autowired
	ApplicationSettingsService appSettingsService;

	@Autowired
	DataSource dataSource;

	@Autowired
	private ApplicationContext appContext;

	@RequestMapping(value = "reset-db", method = RequestMethod.GET)
	public ModelAndView resetDatabaseConfirmation(HttpServletRequest request, HttpServletResponse response,
			@CurrentUserDetails CustomUserDetails userDetails) {
		if (userDetails == null || !userDetails.hasRole(UserRole.ROLE_ADMIN))
			return new ModelAndView("accessDenied");
		return new ModelAndView("resetDBconfirmation");
	}

	@RequestMapping(value = "reset-db/execute", method = RequestMethod.POST)
	public ModelAndView resetDatabase(HttpServletRequest request, HttpServletResponse response, @CurrentUserDetails CustomUserDetails userDetails,
			ModelMap model) throws ScriptException, SQLException {
		if (userDetails == null || !userDetails.hasRole(UserRole.ROLE_ADMIN))
			return new ModelAndView("accessDenied");

		// LocalSessionFactoryBean session = (LocalSessionFactoryBean) appContext.getBean("&sessionFactory");
		// SchemaExport export = new SchemaExport(session.getConfiguration());
		// export.drop(false, true);
		// export.create(false, true);
		// model.put("user", userDetails);
		final ResourceDatabasePopulator rdp = new ResourceDatabasePopulator();
		rdp.addScript(appContext.getResource("classpath:db/initDB.sql"));
		rdp.addScript(appContext.getResource("classpath:db/alter.sql"));
		rdp.addScript(appContext.getResource("classpath:db/testing_project_handler.sql"));
		rdp.populate(dataSource.getConnection());

		return new ModelAndView("redirect:/", model);
	}

}
