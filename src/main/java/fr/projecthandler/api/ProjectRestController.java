package fr.projecthandler.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import fr.projecthandler.model.Project;
import fr.projecthandler.service.ProjectService;
import fr.projecthandler.service.TokenService;
import fr.projecthandler.service.UserService;

@RestController
@Transactional
@RequestMapping("/api/project")
public class ProjectRestController {

	@Autowired
	UserService userService;

	@Autowired
	TokenService tokenService;

	@Autowired
	ProjectService projectService;

	@Autowired
	private UserDetailsService customUserDetailsService;

	@RequestMapping(value = "/get/{id}", method = RequestMethod.GET)
	public @ResponseBody ResponseEntity<String> get(@PathVariable Long id) {
		Project project = projectService.findProjectById(id);

		if (project == null) {
			return new ResponseEntity<String>(
					"{\"status\":400, \"project\":\"Not found\"}",
					HttpStatus.NOT_FOUND);
		}

		Gson gson = new GsonBuilder().setExclusionStrategies(
				new ApiExclusionStrategy()).create();
		try {
			String json = gson.toJson(project);

			return new ResponseEntity<String>(json, HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<String>("KO", HttpStatus.BAD_REQUEST);
		}
	}

}
