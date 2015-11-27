package fr.projecthandler.api;

import fr.projecthandler.annotation.CurrentUserDetails;
import fr.projecthandler.api.exception.ApiAccessDeniedException;
import fr.projecthandler.api.exception.ApiNotFoundException;
import fr.projecthandler.dto.MobileSubTaskDTO;
import fr.projecthandler.dto.MobileTaskDTO;
import fr.projecthandler.model.SubTask;
import fr.projecthandler.model.Task;
import fr.projecthandler.service.ProjectService;
import fr.projecthandler.service.SubTaskService;
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
@Api(value = "Task", description = "Operations about tasks")
@RequestMapping(value = "/api/task", produces = MediaType.APPLICATION_JSON_VALUE + ";charset=UTF-8")
public class TaskRestController {

	private static final Logger log = LoggerFactory.getLogger(TaskRestController.class);

	@Autowired
	UserService userService;

	@Autowired
	ProjectService projectService;

	@Autowired
	TokenService tokenService;

	@Autowired
	TaskService taskService;

	@Autowired
	SubTaskService subTaskService;

	@RequestMapping(value = "/allByProject/{projectId}", method = RequestMethod.GET)
	@ApiOperation(value = "Gets tasks by project id ", notes = "Returns the list of tasks linked to the project", response = MobileTaskDTO.class)
	@ApiResponses(value = {
			@ApiResponse(code = HttpServletResponse.SC_OK, message = "Successful retrieval of tasks", response = MobileTaskDTO.class),
			@ApiResponse(code = HttpServletResponse.SC_NOT_FOUND, message = "Project with given id does not exist") })
	public ResponseEntity<String> getTasksByProjectId(@ApiIgnore @CurrentUserDetails CustomUserDetails userDetails,
			@PathVariable Long projectId) throws ApiAccessDeniedException {
		if (!projectService.isUserInProject(userDetails.getId(), projectId)) {
			throw new ApiAccessDeniedException();
		}
		Set<Task> taskList = taskService.getTasksByProjectIdWithDependsAndSubtask(projectId);

		List<MobileTaskDTO> taskListDTO = new ArrayList<MobileTaskDTO>();
		for (Task t : taskList)
			taskListDTO.add(new MobileTaskDTO(t));

		Gson gson = new GsonBuilder().setExclusionStrategies(new ApiExclusionStrategy()).create();
		String json = gson.toJson(taskListDTO);
		return new ResponseEntity<String>(json, HttpStatus.OK);
	}

	@RequestMapping(value = { "/allByProjectAndUser/{projectId}", "/allByProjectAndCurrentUser/{projectId}" }, method = RequestMethod.GET)
	@ApiOperation(value = "Gets tasks assigned to the authenticated user by project id", notes = "Returns the list of tasks linked to the project and assigned to the current user", response = MobileTaskDTO.class)
	@ApiResponses(value = {
			@ApiResponse(code = HttpServletResponse.SC_OK, message = "Successful retrieval of tasks", response = MobileTaskDTO.class),
			@ApiResponse(code = HttpServletResponse.SC_NOT_FOUND, message = "Project with given id does not exist") })
	public ResponseEntity<String> getTasksByProjectAndCurrentUser(@PathVariable Long projectId,
			@ApiIgnore @CurrentUserDetails CustomUserDetails userDetails) throws ApiNotFoundException {
		Set<Task> taskList = taskService.getTasksByProjectIdAndUserIdWithDependsAndSubtask(projectId, userDetails.getId());

		// TODO Not found if projectId is invalid, empty if no task
		if (taskList == null)
			throw new ApiNotFoundException(projectId);

		List<MobileTaskDTO> taskListDTO = new ArrayList<MobileTaskDTO>();
		for (Task t : taskList)
			taskListDTO.add(new MobileTaskDTO(t));

		Gson gson = new GsonBuilder().setExclusionStrategies(new ApiExclusionStrategy()).create();
		String json = gson.toJson(taskListDTO);
		return new ResponseEntity<String>(json, HttpStatus.OK);
	}

	@RequestMapping(value = "/allByUser", method = RequestMethod.GET)
	@ApiOperation(value = "Gets all tasks assigned to the authenticated user", notes = "Returns the list of tasks assigned to the authenticated user", response = MobileTaskDTO.class)
	@ApiResponses(value = { @ApiResponse(code = HttpServletResponse.SC_OK, message = "Successful retrieval of tasks", response = MobileTaskDTO.class) })
	public ResponseEntity<String> getAllByUser(@ApiIgnore @CurrentUserDetails CustomUserDetails userDetails) {
		Set<Task> taskList = taskService.getTasksByUser(userDetails.getId());
		if (taskList == null)
			return new ResponseEntity<String>("{\"status\":400, \"project\":\"Not found\"}", HttpStatus.NOT_FOUND);

		List<MobileTaskDTO> taskListDTO = new ArrayList<MobileTaskDTO>();
		for (Task t : taskList)
			taskListDTO.add(new MobileTaskDTO(t));

		Gson gson = new GsonBuilder().setExclusionStrategies(new ApiExclusionStrategy()).create();
		String json = gson.toJson(taskListDTO);
		return new ResponseEntity<String>(json, HttpStatus.OK);
	}

	@ApiOperation(value = "Updates an existing subtask", notes = "This request will be obsolete in the next version of the API. It will be replaced by a PUT request.", response = MobileSubTaskDTO.class)
	@ApiResponses(value = { @ApiResponse(code = HttpServletResponse.SC_OK, message = "Successful update"),
			@ApiResponse(code = HttpServletResponse.SC_NOT_FOUND, message = "Subtask with given id does not exist") })
	@RequestMapping(value = "/updateSubTask/{id}/{isTaken}/{isValidated}", method = RequestMethod.GET)
	public ResponseEntity<String> updateSubTask(@PathVariable Long id, @PathVariable Boolean isTaken,
			@PathVariable Boolean isValidated, @ApiIgnore @CurrentUserDetails CustomUserDetails userDetails) {
		SubTask subTask = subTaskService.findSubTaskById(id);
		subTask.setTaken(isTaken);
		subTask.setValidated(isValidated);
		subTaskService.updateSubTask(subTask);

		Gson gson = new GsonBuilder().setExclusionStrategies(new ApiExclusionStrategy()).create();
		String json = gson.toJson(new MobileSubTaskDTO(subTask));
		return new ResponseEntity<String>(json, HttpStatus.OK);
	}
}
