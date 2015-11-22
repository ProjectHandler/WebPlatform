package fr.projecthandler.web;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.security.Principal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.ResourceBundle;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.configuration.Configuration;
import org.apache.commons.configuration.ConfigurationException;
import org.apache.commons.configuration.PropertiesConfiguration;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomCollectionEditor;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import fr.projecthandler.model.SubTask;
import fr.projecthandler.model.Task;
import fr.projecthandler.model.TaskDocument;
import fr.projecthandler.model.TaskMessage;
import fr.projecthandler.model.User;
import fr.projecthandler.service.ProjectService;
import fr.projecthandler.service.SubTaskService;
import fr.projecthandler.service.TaskDocumentService;
import fr.projecthandler.service.TaskMessageService;
import fr.projecthandler.service.TaskService;
import fr.projecthandler.service.UserService;
import fr.projecthandler.session.CustomUserDetails;
import fr.projecthandler.util.Utilities;

@Controller
public class TaskController {

	private static final Log log = LogFactory.getLog(TaskController.class);

	@Autowired
	UserService userService;

	@Autowired
	TaskService taskService;

	@Autowired
	SubTaskService subTaskService;

	@Autowired
	TaskMessageService taskMessageService;

	@Autowired
	ProjectService projectService;
	
	@Autowired
	TaskDocumentService taskDocumentService;

	@Autowired
	HttpSession httpSession;

	@InitBinder
	protected void initBinder(HttpServletRequest request, ServletRequestDataBinder binder) throws Exception {
		binder.registerCustomEditor(List.class, new CustomCollectionEditor(List.class) {
			@Override
			protected Object convertElement(Object element) {
				String userId = (String) element;
				return userService.findUserById(Long.valueOf(userId));
			}
		});
	}

	@RequestMapping(value = "task/changePriority", method = RequestMethod.GET)
	public @ResponseBody String changePriority(Principal principal, @RequestParam("taskId") Long taskId, @RequestParam("priorityId") Long priority) {
		Locale locale = Locale.FRANCE; // TMP (use actual local later...)
		ResourceBundle bundle = ResourceBundle.getBundle("messages/messages", locale);
		if (principal == null) {
			return "redirect:/accessDenied";
		} else {
			Task t = taskService.findTaskById(taskId);
			if (t == null)
				return "KO: " + bundle.getString("projecthandler.taskBoxView.error.taskNotExists");
			t.setPriority(taskService.findTaskPriorityById(priority));
			try {
				taskService.updateTask(t);
			} catch (Exception e) {
				log.error("error for changing task proprity (task id: " + taskId + ", priority id: " + priority + ")", e);
				return "KO: " + bundle.getString("projecthandler.taskBoxView.error.taskPriorityNotChanged");
			}
		}
		return "OK";
	}

	@RequestMapping(value = "task/updateProgress", method = RequestMethod.GET)
	public @ResponseBody String updateProgress(Principal principal, @RequestParam("taskId") Long taskId, @RequestParam("progress") Long progress) {
		Locale locale = Locale.FRANCE; // TMP (use actual local later...)
		ResourceBundle bundle = ResourceBundle.getBundle("messages/messages", locale);
		if (principal == null) {
			return "redirect:/accessDenied";
		} else {
			Task t = taskService.findTaskById(taskId);
			if (t == null)
				return "KO: " + bundle.getString("projecthandler.taskBoxView.error.taskNotExists");
			t.setProgress(progress); // compute Server side only ???
			if (progress == 100)
				t.setStatus("STATUS_DONE");
			else
				t.setStatus("STATUS_ACTIVE");
			try {
				taskService.updateTask(t);
			} catch (Exception e) {
				log.error("error updating progress (task id: " + taskId + ", progress: " + progress + ")", e);
				return "KO: " + bundle.getString("projecthandler.taskBoxView.error.taskProgressNotChanged");
			}
		}
		return "OK";
	}

	@RequestMapping(value = "subTask/save", method = RequestMethod.GET)
	public @ResponseBody String saveSubTask(Principal principal, @RequestParam("description") String description,
			@RequestParam("userId") Long userId, @RequestParam("taskId") Long taskId) {
		Locale locale = Locale.FRANCE; // TMP (use actual local later...)
		ResourceBundle bundle = ResourceBundle.getBundle("messages/messages", locale);
		SubTask subTask = new SubTask();
		if (principal == null) {
			return "redirect:/accessDenied";
		} else {
			subTask.setDescription(description);
			subTask.setLastUserActivity(userService.findUserById(userId));
			subTask.setParentTask(taskService.findTaskById(taskId));
			try {
				subTaskService.saveSubtask(subTask);
			} catch (Exception e) {
				log.error("error saving subtask (task id: " + taskId + ", user id: " + userId + ")", e);
				return "KO: " + bundle.getString("projecthandler.taskBoxView.error.subTaskNotUpdated");
			}
		}
		Gson gson = new GsonBuilder().excludeFieldsWithoutExposeAnnotation().create();
		return gson.toJson(subTask);
	}

	// TODO checkbox text enum
	@RequestMapping(value = "subTask/update/full", method = RequestMethod.GET)
	public @ResponseBody String updateSubTask(Principal principal, @RequestParam("description") String description,
			@RequestParam("userId") Long userId, @RequestParam("subTaskId") Long subTaskId, @RequestParam("state") String state) {
		Locale locale = Locale.FRANCE; // TMP (use actual local later...)
		ResourceBundle bundle = ResourceBundle.getBundle("messages/messages", locale);
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
			} else if (state.equals("taken")) {
				subTask.setTaken(true);
				subTask.setValidated(false);
			} else {
				subTask.setTaken(false);
				subTask.setValidated(false);
			}
			try {
				subTaskService.updateSubTask(subTask);
			} catch (Exception e) {
				log.error("error updating full subtask (subtask id: " + subTaskId + ", user id: " + userId + ")", e);
				return "KO: " + bundle.getString("projecthandler.taskBoxView.error.subTaskNotUpdated");
			}
		}
		return "OK";
	}

	// TODO checkbox text enum
	@RequestMapping(value = "subTask/update/state", method = RequestMethod.GET)
	public @ResponseBody String updateSubTaskState(Principal principal, @RequestParam("userId") Long userId,
			@RequestParam("subTaskId") Long subTaskId, @RequestParam("state") String state) {
		SubTask subTask = subTaskService.findSubTaskById(subTaskId);
		Locale locale = Locale.FRANCE; // TMP (use actual local later...)
		ResourceBundle bundle = ResourceBundle.getBundle("messages/messages", locale);
		if (principal == null) {
			return "redirect:/accessDenied";
		} else {
			if (subTask == null)
				return "KO: " + bundle.getString("projecthandler.taskBoxView.error.subTaskNotExists");
			subTask.setLastUserActivity(userService.findUserById(userId));
			if (state.equals("validated")) {
				subTask.setValidated(true);
				subTask.setTaken(false);
			} else if (state.equals("taken")) {
				subTask.setTaken(true);
				subTask.setValidated(false);
			} else {
				subTask.setTaken(false);
				subTask.setValidated(false);
			}
			try {
				subTaskService.updateSubTask(subTask);
			} catch (Exception e) {
				log.error("error updating state subtask (subtask id: " + subTaskId + ", user id: " + userId + ")", e);
				return "KO: " + bundle.getString("projecthandler.taskBoxView.error.subTaskNotUpdated");
			}
		}
		Gson gson = new GsonBuilder().excludeFieldsWithoutExposeAnnotation().create();
		return gson.toJson(subTask);
	}

	@RequestMapping(value = "subTask/update/description", method = RequestMethod.GET)
	public @ResponseBody String updateSubTaskDescription(Principal principal, @RequestParam("description") String description,
			@RequestParam("subTaskId") Long subTaskId) {
		SubTask subTask = subTaskService.findSubTaskById(subTaskId);
		Locale locale = Locale.FRANCE; // TMP (use actual local later...)
		ResourceBundle bundle = ResourceBundle.getBundle("messages/messages", locale);
		if (principal == null) {
			return "redirect:/accessDenied";
		} else {
			if (subTask == null)
				return "KO: " + bundle.getString("projecthandler.taskBoxView.error.subTaskNotExists");
			subTask.setDescription(description);
			try {
				subTaskService.updateSubTask(subTask);
			} catch (Exception e) {
				log.error("error updating description subtask (subtask id: " + subTaskId + ")", e);
				return "KO: " + bundle.getString("projecthandler.taskBoxView.error.subTaskNotUpdated");
			}
		}
		return "OK";
	}

	@RequestMapping(value = "subTask/delete", method = RequestMethod.GET)
	public @ResponseBody String deleteSubTask(Principal principal, @RequestParam("userId") Long userId, @RequestParam("subTaskId") Long subTaskId) {
		SubTask subTask = subTaskService.findSubTaskById(subTaskId);
		Locale locale = Locale.FRANCE; // TMP (use actual local later...)
		ResourceBundle bundle = ResourceBundle.getBundle("messages/messages", locale);

		if (principal == null) {
			return "redirect:/accessDenied";
		} else {
			if (subTask == null)
				return "KO: " + bundle.getString("projecthandler.taskBoxView.error.subTaskNotExists");
			if (subTask.isTaken() && !subTask.getLastUserActivity().getId().equals(userId))
				return "KO: " + bundle.getString("projecthandler.taskBoxView.error.deleteSubTaskTakenByOther");
			try {
				subTaskService.deleteSubTaskById(subTaskId);
			} catch (Exception e) {
				log.error("error deleting subtask (subtask id: " + subTaskId + ", user id: " + userId + ")", e);
				return "KO: " + bundle.getString("projecthandler.taskBoxView.error.subTaskNotDeleted");
			}
		}
		return "OK";
	}

	@RequestMapping(value = "task/comment/save", method = RequestMethod.GET)
	public @ResponseBody String saveNewComment(Principal principal, @RequestParam("content") String content, @RequestParam("userId") Long userId,
			@RequestParam("taskId") Long taskId) {
		Locale locale = Locale.FRANCE; // TMP (use actual local later...)
		ResourceBundle bundle = ResourceBundle.getBundle("messages/messages", locale);
		TaskMessage taskMessage = new TaskMessage();

		if (principal == null) {
			return "redirect:/accessDenied";
		} else {
			taskMessage.setContent(content);
			taskMessage.setOwner(userService.findUserById(userId));
			taskMessage.setTask(taskService.findTaskById(taskId));
			taskMessage.setUpdateDate(new Date());
			try {
				taskMessageService.saveTaskMessage(taskMessage);
			} catch (Exception e) {
				log.error("error saving task comment (task id: " + taskId + ", user id: " + userId + ")", e);
				return "KO: " + bundle.getString("projecthandler.taskBoxMessages.error.commentNotSaved");
			}
		}
		Gson gson = new GsonBuilder().excludeFieldsWithoutExposeAnnotation().create();
		return gson.toJson(taskMessage);
	}

	@RequestMapping(value = "task/comment/delete", method = RequestMethod.GET)
	public @ResponseBody String deleteComment(Principal principal, @RequestParam("commentId") Long commentId, @RequestParam("userId") Long userId) {
		Locale locale = Locale.FRANCE; // TMP (use actual local later...)
		ResourceBundle bundle = ResourceBundle.getBundle("messages/messages", locale);

		if (principal == null) {
			return "redirect:/accessDenied";
		} else {
			TaskMessage taskMessage = taskMessageService.findTaskMessageById(commentId);
			if (taskMessage == null)
				return "KO: " + bundle.getString("projecthandler.taskBoxMessages.error.commentNotFound");
			if (!taskMessage.getOwner().getId().equals(userId))
				return "KO: " + bundle.getString("projecthandler.taskBoxMessages.error.commentNotOwner");
			try {
				taskMessageService.deleteTaskMessageById(commentId);
			} catch (Exception e) {
				log.error("error deleting task comment (comment id: " + commentId + ", user id: " + userId + ")", e);
				return "KO: " + bundle.getString("projecthandler.taskBoxMessages.error.commentNotDeleted");
			}
		}
		return "OK";
	}

	@RequestMapping(value = "task/comment/update", method = RequestMethod.GET)
	public @ResponseBody String updateComment(Principal principal, @RequestParam("content") String content,
			@RequestParam("commentId") Long commentId, @RequestParam("userId") Long userId) {
		Locale locale = Locale.FRANCE; // TMP (use actual local later...)
		ResourceBundle bundle = ResourceBundle.getBundle("messages/messages", locale);
		TaskMessage taskMessage = taskMessageService.findTaskMessageById(commentId);

		if (principal == null) {
			return "redirect:/accessDenied";
		} else {
			if (taskMessage == null)
				return "KO: " + bundle.getString("projecthandler.taskBoxMessages.error.commentNotFound");
			if (!taskMessage.getOwner().getId().equals(userId))
				return "KO: " + bundle.getString("projecthandler.taskBoxMessages.error.commentNotOwner");
			taskMessage.setContent(content);
			taskMessage.setUpdateDate(new Date());
			try {
				taskMessageService.updateTaskMessage(taskMessage);
			} catch (Exception e) {
				log.error("error updating task comment (comment id: " + commentId + ", user id: " + userId + ")", e);
				return "KO: " + bundle.getString("projecthandler.taskBoxMessages.error.commentNotUpdated");
			}
		}
		Gson gson = new GsonBuilder().excludeFieldsWithoutExposeAnnotation().create();
		return gson.toJson(taskMessage);
	}
	
	@RequestMapping(value = "user/draft/save", method = RequestMethod.POST)
	public @ResponseBody String saveUserDraftMessage(Principal principal, @RequestParam("draftMessage") String draftMessage) {
		if (principal != null) {
			User user = null;
			try {
				CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
				user = userService.findUserById(userDetails.getId());
				user.setDrafMessage(draftMessage);
				userService.updateUser(user);
				return "OK";
			} catch (Exception e) {
				log.error("error saving draft", e);
			}
		}
		return "KO";
	}

	@RequestMapping(value = "/task/deleteDocument", method = RequestMethod.POST)
	public @ResponseBody String deleteDocument(@RequestParam("documentId") Long documentId) throws ConfigurationException {
		Locale locale = Locale.FRANCE; // TMP (use actual local later...)
		ResourceBundle bundle = ResourceBundle.getBundle("messages/messages", locale);
		
		Configuration config = new PropertiesConfiguration("spring/path.properties");
		String path = config.getString("folder.path.uploadedFiles");
		
		TaskDocument document = taskDocumentService.findTaskDocumentById(documentId);
		
		if (document != null) {
			File directory = new File(path, document.getProjectId() + "_" + document.getTaskId());
			if (directory.exists()) {
				File fileToDelete = new File(directory, document.getDatabaseName());
				fileToDelete.delete();
				
				if (!fileToDelete.exists()) {
					List<Long> idsList = new ArrayList<Long>();
					idsList.add(documentId);
					taskDocumentService.deleteTaskDocumentsByIds(idsList);

					return "OK";
				}
				else
					return "KO : " + bundle.getString("projecthandler.taskDocumentView.error.deleteDocumentFailed");
			}
			else
				return "KO : " + bundle.getString("projecthandler.taskDocumentView.error.noSuchDirectory");
		}
		return "KO : " + bundle.getString("projecthandler.taskDocumentView.error.noSuchFile");
	}

	@RequestMapping(value = "task/{projectId}/{taskId}/downloadDocument/{documentId}", method = RequestMethod.GET)
	public void downloadDocument(@PathVariable Long documentId, HttpServletResponse response) throws Exception {
		Configuration config = new PropertiesConfiguration("spring/path.properties");
		String path = config.getString("folder.path.uploadedFiles");

		TaskDocument document = taskDocumentService.findTaskDocumentById(documentId);

		File directory = new File(path, document.getProjectId() + "_" + document.getTaskId());

		if (document != null && directory.exists()) {
			File file = new File(directory, document.getDatabaseName());
			if (file != null)
				Utilities.writeFileAsResponseStreamWithFileName(file, response, document.getName());
		}
	}

	@RequestMapping(value = "task/{projectId}/{taskId}/uploadDocument", method = RequestMethod.POST)
	public String uploadDocument(Principal principal, @RequestParam MultipartFile documentToUpload, @PathVariable Long projectId, @PathVariable Long taskId) throws Exception {
		CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
		Configuration config = new PropertiesConfiguration("spring/path.properties");
		String path = config.getString("folder.path.uploadedFiles");
		
		File directory = new File(path, projectId + "_" + taskId);
		if (!directory.exists())
			directory.mkdirs();
		
		User user = userService.findUserById(userDetails.getId());
		if (user != null) {
			BufferedOutputStream out = null;
			String documentDatabaseName = FilenameUtils.removeExtension(documentToUpload.getOriginalFilename()) + "_" + UUID.randomUUID().toString();
			File document = null;
			try {
				// save document
				document = new File(directory, documentDatabaseName);
				out = new BufferedOutputStream(new FileOutputStream(document));
				out.write(documentToUpload.getBytes());
				if (out != null) {
					out.close();
				}
				TaskDocument taskDocument = new TaskDocument();
				taskDocument.setProjectId(projectId);
				taskDocument.setTaskId(taskId);
				taskDocument.setName(documentToUpload.getOriginalFilename());
				taskDocument.setDatabaseName(documentDatabaseName);
				taskDocument.setDocumentExtension(documentToUpload.getContentType());
				taskDocument.setDocumentSize(documentToUpload.getSize());
				taskDocument.setUploadDate(new Date());
				taskDocumentService.saveTaskDocument(taskDocument);
			} catch (Exception e) {
				throw new Exception("Error uploading file...", e);
			}
		}

		return "redirect:/project/viewProject/" + projectId + "/tasks/" + taskId;
	}
}
