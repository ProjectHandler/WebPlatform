package fr.projecthandler.api;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import fr.projecthandler.annotation.CurrentUserDetails;
import fr.projecthandler.dto.MobileSubTaskDTO;
import fr.projecthandler.dto.MobileTaskDTO;
import fr.projecthandler.model.SubTask;
import fr.projecthandler.model.Task;
import fr.projecthandler.service.SubTaskService;
import fr.projecthandler.service.TaskService;
import fr.projecthandler.service.TokenService;
import fr.projecthandler.service.UserService;
import fr.projecthandler.session.CustomUserDetails;

@RestController
@Transactional
@RequestMapping("/api/task")
public class TaskRestController {

	@Autowired
	UserService userService;

	@Autowired
	TokenService tokenService;

	@Autowired
	TaskService taskService;

	@Autowired
	SubTaskService subTaskService;

	@Autowired
	private UserDetailsService customUserDetailsService;

	@RequestMapping(value = "/allByProject/{projectId}", method = RequestMethod.GET)
	public @ResponseBody ResponseEntity<String> getProjects(@PathVariable Long projectId, @CurrentUserDetails CustomUserDetails userDetails) {
		Set<Task> taskList = taskService.getTasksByProjectIdWithDepends(projectId);

		if (taskList == null) {
			return new ResponseEntity<String>("{\"status\":400, \"project\":\"Not found\"}", HttpStatus.NOT_FOUND);
		}

		List<MobileTaskDTO> taskListDTO = new ArrayList<MobileTaskDTO>();
		for (Task t : taskList) {
			MobileTaskDTO taskDTO = new MobileTaskDTO(t);

			Set<SubTask> listSubTask = subTaskService.getSubTasksByTaskId(t.getId());
			Set<MobileSubTaskDTO> listSubTaskDTO = new HashSet<>();
			for (SubTask subTask : listSubTask) {
				listSubTaskDTO.add(new MobileSubTaskDTO(subTask));
			}
			taskDTO.setSubTask(listSubTaskDTO);
			taskListDTO.add(taskDTO);
		}

		Gson gson = new GsonBuilder().setExclusionStrategies(new ApiExclusionStrategy()).create();

		try {
			String json = gson.toJson(taskListDTO);
			return new ResponseEntity<String>(json, HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<String>("KO", HttpStatus.BAD_REQUEST);
		}

	}

	@RequestMapping(value = "/allByProjectAndUser/{projectId}", method = RequestMethod.GET)
	public @ResponseBody ResponseEntity<String> getProjectsByUser(@PathVariable Long projectId, @CurrentUserDetails CustomUserDetails userDetails) {
		Set<Task> taskList = taskService.getTasksByProjectIdAndUserIdWithDepends(projectId, userDetails.getId());

		if (taskList == null) {
			return new ResponseEntity<String>("{\"status\":400, \"project\":\"Not found\"}", HttpStatus.NOT_FOUND);
		}

		List<MobileTaskDTO> taskListDTO = new ArrayList<MobileTaskDTO>();
		for (Task t : taskList) {
			MobileTaskDTO taskDTO = new MobileTaskDTO(t);
			Set<SubTask> listSubTask = subTaskService.getSubTasksByTaskId(t.getId());
			Set<MobileSubTaskDTO> listSubTaskDTO = new HashSet<>();
			for (SubTask subTask : listSubTask) {
				listSubTaskDTO.add(new MobileSubTaskDTO(subTask));
			}
			taskDTO.setSubTask(listSubTaskDTO);
			taskListDTO.add(taskDTO);
		}

		Gson gson = new GsonBuilder().setExclusionStrategies(new ApiExclusionStrategy()).create();

		try {
			String json = gson.toJson(taskListDTO);
			return new ResponseEntity<String>(json, HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<String>("KO", HttpStatus.BAD_REQUEST);
		}
	}

	@RequestMapping(value = "/allByUser", method = RequestMethod.GET)
	public @ResponseBody ResponseEntity<String> getAllByUser(@CurrentUserDetails CustomUserDetails userDetails) {
		try {
			Set<Task> taskList = taskService.getTasksByUser(userDetails.getId());

			if (taskList == null) {
				return new ResponseEntity<String>("{\"status\":400, \"project\":\"Not found\"}", HttpStatus.NOT_FOUND);
			}

			List<MobileTaskDTO> taskListDTO = new ArrayList<MobileTaskDTO>();
			for (Task t : taskList) {
				MobileTaskDTO taskDTO = new MobileTaskDTO(t);
				Set<SubTask> listSubTask = subTaskService.getSubTasksByTaskId(t.getId());
				Set<MobileSubTaskDTO> listSubTaskDTO = new HashSet<>();
				for (SubTask subTask : listSubTask) {
					listSubTaskDTO.add(new MobileSubTaskDTO(subTask));
				}
				taskDTO.setSubTask(listSubTaskDTO);
				taskListDTO.add(taskDTO);
			}

			Gson gson = new GsonBuilder().setExclusionStrategies(new ApiExclusionStrategy()).create();

			String json = gson.toJson(taskListDTO);
			System.out.println(json);
			return new ResponseEntity<String>(json, HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<String>("KO", HttpStatus.BAD_REQUEST);
		}
	}
	
	@RequestMapping(value = "/updateSubTask/{id}/{isValidated}", method = RequestMethod.GET)
	public @ResponseBody ResponseEntity<String> updateSubTask(@PathVariable Long id, @PathVariable Boolean isValidated,
			@CurrentUserDetails CustomUserDetails userDetails) {
		
		try {
			SubTask subTask = subTaskService.findSubTaskById(id);
			subTask.setValidated(isValidated);
			subTaskService.updateSubTask(subTask);

			System.out.println("ok");
			System.out.println("id: " + id + " isValidated:" + isValidated);
			
			Gson gson = new GsonBuilder().setExclusionStrategies(new ApiExclusionStrategy()).create();

			String json = gson.toJson(new MobileSubTaskDTO(subTask));
			System.out.println(json);
			return new ResponseEntity<String>(json, HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<String>("KO", HttpStatus.BAD_REQUEST);
		}
	}
}
