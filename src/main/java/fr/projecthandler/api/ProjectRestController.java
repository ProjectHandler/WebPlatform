package fr.projecthandler.api;

import fr.projecthandler.annotation.CurrentUserDetails;
import fr.projecthandler.api.exception.ApiNotFoundException;
import fr.projecthandler.dto.MobileProjectDTO;
import fr.projecthandler.dto.ProjectProgressDTO;
import fr.projecthandler.model.Project;
import fr.projecthandler.model.Task;
import fr.projecthandler.service.ProjectService;
import fr.projecthandler.service.TaskService;
import fr.projecthandler.service.TokenService;
import fr.projecthandler.service.UserService;
import fr.projecthandler.session.CustomUserDetails;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import springfox.documentation.annotations.ApiIgnore;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

@RestController
@Transactional
@Api(value = "Project", description = "Operations about projects")
@RequestMapping(value = "/api/project", produces = MediaType.APPLICATION_JSON_VALUE + ";charset=UTF-8")
public class ProjectRestController {

	private static final Logger log = LoggerFactory.getLogger(ProjectRestController.class);

	@Autowired
	UserService userService;

	@Autowired
	TokenService tokenService;

	@Autowired
	ProjectService projectService;

	@Autowired
	TaskService taskService;

	@RequestMapping(value = "/get/{id}", method = RequestMethod.GET)
	@ApiOperation(value = "Find project by project id", response = MobileProjectDTO.class)
	@ApiResponses(value = {
			@ApiResponse(code = HttpServletResponse.SC_OK, message = "Successful retrieval of project", response = MobileProjectDTO.class),
			@ApiResponse(code = HttpServletResponse.SC_NOT_FOUND, message = "Project with given id does not exist") })
	public ResponseEntity<String> get(@PathVariable Long id) throws ApiNotFoundException {
		Project project = projectService.findProjectById(id);

		if (project == null)
			throw new ApiNotFoundException(id);

		project.setTasks(taskService.getTasksByProjectId(project.getId())); // TODO propre
		MobileProjectDTO projectDTO = new MobileProjectDTO(project);
		Gson gson = new GsonBuilder().setExclusionStrategies(new ApiExclusionStrategy()).create();

		String json = gson.toJson(projectDTO);

		return new ResponseEntity<String>(json, HttpStatus.OK);
	}

	@RequestMapping(value = { "/allByUser", "/allByCurrentUser" }, method = RequestMethod.GET)
	@ApiOperation(value = "Gets project by authenticated user", response = MobileProjectDTO.class)
	@ApiResponses(value = { @ApiResponse(code = HttpServletResponse.SC_OK, message = "Successful retrieval of projects", response = MobileProjectDTO.class), })
	public ResponseEntity<String> getAllProjectsByCurrentUser(@ApiIgnore @CurrentUserDetails CustomUserDetails userDetails)
			throws ApiNotFoundException {
		List<Project> projectList = projectService.getProjectsByUserIdAndFetchTasks(userDetails.getId());

		List<MobileProjectDTO> projectListDTO = new ArrayList<MobileProjectDTO>();
		for (Project project : projectList) {
			MobileProjectDTO projectDTO = new MobileProjectDTO(project);

			Set<Task> tasks = taskService.getTasksByProjectId(project.getId());
			ProjectProgressDTO projectProgressDTO = new ProjectProgressDTO(project, tasks);
			projectDTO.setDateProgress(projectProgressDTO.getDateProgress());
			projectDTO.setDaysLeft(projectProgressDTO.getDaysLeft());
			projectDTO.setTasksProgress(projectProgressDTO.getTasksProgress());
			projectListDTO.add(projectDTO);
		}

		Gson gson = new GsonBuilder().setExclusionStrategies(new ApiExclusionStrategy()).create();
		String json = gson.toJson(projectListDTO);
		return new ResponseEntity<String>(json, HttpStatus.OK);
	}
}
