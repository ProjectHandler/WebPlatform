package fr.projecthandler.web;

import java.io.File;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Properties;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

import org.apache.commons.configuration.PropertiesConfiguration;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.hibernate.cfg.Configuration;
import org.hibernate.dialect.MySQLDialect;
import org.hibernate.dialect.PostgreSQL82Dialect;
import org.hibernate.tool.hbm2ddl.SchemaExport;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.ApplicationContext;
import org.springframework.jdbc.datasource.init.ResourceDatabasePopulator;
import org.springframework.jdbc.datasource.init.ScriptException;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import fr.projecthandler.annotation.CurrentUserDetails;
import fr.projecthandler.enums.UserRole;
import fr.projecthandler.service.ApplicationSettingsService;
import fr.projecthandler.session.CustomUserDetails;
import fr.projecthandler.util.Utilities;

@Controller
@RequestMapping("debug")
public class DebugController {

	@PersistenceContext
	protected EntityManager em;

	private static final Log log = LogFactory.getLog(DebugController.class);

	@Autowired
	ApplicationSettingsService appSettingsService;

	@Autowired
	DataSource dataSource;

	@Autowired
	private ApplicationContext appContext;

	@RequestMapping(method = RequestMethod.GET)
	public ModelAndView resetDatabaseConfirmation(HttpServletRequest request, HttpServletResponse response,
			@CurrentUserDetails CustomUserDetails userDetails) {
		if (userDetails == null || !userDetails.hasRole(UserRole.ROLE_ADMIN))
			return new ModelAndView("accessDenied");
		return new ModelAndView("debug");
	}

	@RequestMapping(value = "reset-db/my-sql/execute", method = RequestMethod.POST)
	public ModelAndView resetDatabase(HttpServletRequest request, HttpServletResponse response, @CurrentUserDetails CustomUserDetails userDetails)
			throws Exception {
		if (userDetails == null || !userDetails.hasRole(UserRole.ROLE_ADMIN))
			return new ModelAndView("accessDenied");

		// LocalSessionFactoryBean session = (LocalSessionFactoryBean) appContext.getBean("&sessionFactory");
		final ResourceDatabasePopulator rdp = new ResourceDatabasePopulator();
		rdp.addScript(appContext.getResource("classpath:db/initDB.sql"));
		rdp.addScript(appContext.getResource("classpath:db/alter.sql"));
		rdp.addScript(appContext.getResource("classpath:db/testing_project_handler.sql"));
		try {
			rdp.populate(dataSource.getConnection());
		} catch (ScriptException | SQLException e) {
			log.error("resetDatabase error");
			throw e;
		}

		return new ModelAndView("redirect:/");
	}

	@RequestMapping(value = "get/schema", method = RequestMethod.GET)
	public ModelAndView getSchema(HttpServletRequest request, HttpServletResponse response, @CurrentUserDetails CustomUserDetails userDetails,
			ModelMap model, @RequestParam String dialect, @RequestParam(required = false) String just_create) throws Exception {
		if (userDetails == null || !userDetails.hasRole(UserRole.ROLE_ADMIN))
			return new ModelAndView("accessDenied");

		// Set configuration parameters based on GET parameters
		boolean justCreate = just_create.equals("true");
		String dialectClass;
		switch (dialect) {
		case "mysql":
			dialectClass = MySQLDialect.class.getName();
			break;
		case "postgresql":
			dialectClass = PostgreSQL82Dialect.class.getName();
			break;
		default:
			return new ModelAndView("pageNotFound");
		}

		// Configure SchemaExport
		// Ejb3Configuration jpaConfiguration = new Ejb3Configuration().configure("persistenceUnit", null);
		Configuration cfg = new Configuration();
		Properties properties = new Properties();
		properties.put("hibernate.dialect", dialectClass);
		for (Class<?> clazz : Utilities.getClasses("fr.projecthandler.model")) {
			cfg.addAnnotatedClass(clazz);
		}
		cfg.addProperties(properties);

		SchemaExport export = new SchemaExport(cfg);
		export.setDelimiter(";");
		PropertiesConfiguration config = new PropertiesConfiguration("spring/path.properties");
		// Set output file
		String path = config.getString("folder.path");
		String date = new SimpleDateFormat("dd-MM-yyyy_HH-mm").format(new Date());
		String filebasename = dialect + "_" + date + ".sql";
		export.setOutputFile(Paths.get(path, filebasename).toString());
		// Generate the DDL and copy it to the output file. The script is not executed on the database.
		export.execute(true, false, false, justCreate);

		// Copy script to the response stream and delete it afterwards
		File file = new File(path, filebasename);
		if (file != null)
			Utilities.writeFileAsResponseStreamWithFileName(file, response, filebasename);
		if (!file.delete()) {
			log.error("getSchema: delete operation failed");
		}
		return null;
	}
}
