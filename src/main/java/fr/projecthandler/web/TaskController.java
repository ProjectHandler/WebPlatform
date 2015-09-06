package fr.projecthandler.web;

import java.security.Principal;
import java.util.List;
import java.util.ResourceBundle;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomCollectionEditor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import fr.projecthandler.model.SubTask;
import fr.projecthandler.model.Task;
import fr.projecthandler.service.SubTaskService;
import fr.projecthandler.service.TaskService;
import fr.projecthandler.service.UserService;

@Controller
public class TaskController {
	@Autowired
	UserService userService;

	@Autowired
	TaskService taskService;

	@Autowired
	SubTaskService subTaskService;

	@Autowired
	HttpSession httpSession;

	@InitBinder
	protected void initBinder(HttpServletRequest request,
			ServletRequestDataBinder binder) throws Exception {
		binder.registerCustomEditor(List.class, new CustomCollectionEditor(
				List.class) {
			@Override
			protected Object convertElement(Object element) {
				String userId = (String) element;
				return userService.findUserById(Long.valueOf(userId));
			}
		});
	}

	@RequestMapping(value = "task/changePriority", method = RequestMethod.GET)
	public @ResponseBody String changePriority(Principal principal,
											   @RequestParam("taskId") Long taskId,
											   @RequestParam("priorityId") Long priority) {
		ResourceBundle bundle = ResourceBundle.getBundle("messages/messages");
		if (principal == null) {
			return "redirect:/accessDenied";
		} else {
			Task t = taskService.findTaskById(taskId);
			t.setPriority(taskService.findTaskPriorityById(priority));
			try {
				taskService.updateTask(t);
			}
			catch (Exception e) {
				e.printStackTrace();
				return "KO: " + bundle.getString("projecthandler.taskBoxView.error.taskPriorityNotChanged") +
					   "\nError:" + e.getMessage();
			}
		}
		return "OK";
	}

	@RequestMapping(value = "subTask/save", method = RequestMethod.GET)
	public @ResponseBody String saveSubTask(Principal principal,
											@RequestParam("description") String description,
											@RequestParam("userId") Long userId,
											@RequestParam("taskId") Long taskId) {
		ResourceBundle bundle = ResourceBundle.getBundle("messages/messages");
		SubTask subTask = new SubTask();
		if (principal == null) {
			return "redirect:/accessDenied";
		} else {
			subTask.setDescription(description);
			subTask.setLastUserActivity(userService.findUserById(userId));
			subTask.setParentTask(taskService.findTaskById(taskId));
			try {
				subTaskService.saveSubtask(subTask);
			}
			catch (Exception e) {
				e.printStackTrace();
				return "KO: " + bundle.getString("projecthandler.taskBoxView.error.subTaskNotUpdated") +
					   "\nError:" + e.getMessage();
			}
		}
		Gson gson = new GsonBuilder().excludeFieldsWithoutExposeAnnotation().create();
		return gson.toJson(subTask);
	}

	// TODO checkbox text enum
	@RequestMapping(value = "subTask/update/full", method = RequestMethod.GET)
	public @ResponseBody String updateSubTask(Principal principal,
											  @RequestParam("description") String description,
											  @RequestParam("userId") Long userId,
											  @RequestParam("subTaskId") Long subTaskId,
											  @RequestParam("state") String state) {
		ResourceBundle bundle = ResourceBundle.getBundle("messages/messages");
		if (principal == null) {
			return "redirect:/accessDenied";
		} else {
			SubTask subTask = subTaskService.findSubTaskById(subTaskId);
			if (subTask == null)
				return "KO: " + bundle.getString("projecthandler.taskBoxView.error.subTaskNotExists");
			subTask.setDescription(description);
			subTask.setLastUserActivity(userService.findUserById(userId));
			if (state.equals("validated")) {
				subTask.setValidated(true);
				subTask.setTaken(false);
			}
			else if (state.equals("taken")) {
				subTask.setTaken(true);
				subTask.setValidated(false);
			}
			else {
				subTask.setTaken(false);
				subTask.setValidated(false);
			}
			try {
				subTaskService.updateSubTask(subTask);
			}
			catch (Exception e) {
				e.printStackTrace();
				return "KO: " + bundle.getString("projecthandler.taskBoxView.error.subTaskNotUpdated") +
					   "\nError:" + e.getMessage();
			}
		}
		return "OK";
	}
	
	// TODO checkbox text enum
	@RequestMapping(value = "subTask/update/state", method = RequestMethod.GET)
	public @ResponseBody String updateSubTaskState(Principal principal,
											  	   @RequestParam("userId") Long userId,
											  	   @RequestParam("subTaskId") Long subTaskId,
											  	   @RequestParam("state") String state) {
		SubTask subTask = subTaskService.findSubTaskById(subTaskId);
		ResourceBundle bundle = ResourceBundle.getBundle("messages/messages");
		if (principal == null) {
			return "redirect:/accessDenied";
		} else {
			if (subTask == null)
				return "KO: " + bundle.getString("projecthandler.taskBoxView.error.subTaskNotExists");
			subTask.setLastUserActivity(userService.findUserById(userId));
			if (state.equals("validated")) {
				subTask.setValidated(true);
				subTask.setTaken(false);
			}
			else if (state.equals("taken")) {
				subTask.setTaken(true);
				subTask.setValidated(false);
			}
			else {
				subTask.setTaken(false);
				subTask.setValidated(false);
			}
			try {
				subTaskService.updateSubTask(subTask);
			}
			catch (Exception e) {
				e.printStackTrace();
				return "KO: " + bundle.getString("projecthandler.taskBoxView.error.subTaskNotUpdated") +
					   "\nError:" + e.getMessage();
			}
		}
		Gson gson = new GsonBuilder().excludeFieldsWithoutExposeAnnotation().create();
		return gson.toJson(subTask);
	}
	
	@RequestMapping(value = "subTask/update/description", method = RequestMethod.GET)
	public @ResponseBody String updateSubTaskDescription(Principal principal,
											  			 @RequestParam("description") String description,
											  			 @RequestParam("subTaskId") Long subTaskId) {
		SubTask subTask = subTaskService.findSubTaskById(subTaskId);
		ResourceBundle bundle = ResourceBundle.getBundle("messages/messages");
		if (principal == null) {
			return "redirect:/accessDenied";
		} else {
			if (subTask == null)
				return "KO: " + bundle.getString("projecthandler.taskBoxView.error.subTaskNotExists");
			subTask.setDescription(description);
			try {
				subTaskService.updateSubTask(subTask);
			}
			catch (Exception e) {
				e.printStackTrace();
				return "KO: " + bundle.getString("projecthandler.taskBoxView.error.subTaskNotUpdated") +
					   "\nError:" + e.getMessage();
			}
		}
		return "OK";
	}
	
	@RequestMapping(value = "subTask/delete", method = RequestMethod.GET)
	public @ResponseBody String deleteSubTask(Principal principal,
								  			  @RequestParam("userId") Long userId,
								  			  @RequestParam("subTaskId") Long subTaskId) {
		SubTask subTask = subTaskService.findSubTaskById(subTaskId);
		ResourceBundle bundle = ResourceBundle.getBundle("messages/messages");
		if (principal == null) {
			return "redirect:/accessDenied";
		} else {
			if (subTask == null)
				return "KO: " + bundle.getString("projecthandler.taskBoxView.error.subTaskNotExists");
			if (subTask.isTaken() && subTask.getLastUserActivity().getId() != userId)
				return "KO: " + bundle.getString("projecthandler.taskBoxView.error.deleteSubTaskTakenByOther");
			try {
				subTaskService.deleteSubTaskById(subTaskId);
			}
			catch (Exception e) {
				e.printStackTrace();
				return "KO: " + bundle.getString("projecthandler.taskBoxView.error.subTaskNotDeleted") +
					   "\nError:" + e.getMessage();
			}
		}
		return "OK";
	}
}
