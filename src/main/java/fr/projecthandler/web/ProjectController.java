package fr.projecthandler.web;

import java.security.Principal;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomCollectionEditor;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import fr.projecthandler.annotation.CurrentUserDetails;
import fr.projecthandler.dto.DataDTO;
import fr.projecthandler.dto.ProjectProgressDTO;
import fr.projecthandler.enums.Priority;
import fr.projecthandler.enums.ProjectStatus;
import fr.projecthandler.enums.TaskLevel;
import fr.projecthandler.enums.UserRole;
import fr.projecthandler.model.Project;
import fr.projecthandler.model.Task;
import fr.projecthandler.model.TaskPriority;
import fr.projecthandler.model.User;
import fr.projecthandler.service.ProjectService;
import fr.projecthandler.service.SubTaskService;
import fr.projecthandler.service.TaskMessageService;
import fr.projecthandler.service.TaskService;
import fr.projecthandler.service.TicketService;
import fr.projecthandler.service.UserService;
import fr.projecthandler.session.CustomUserDetails;
import fr.projecthandler.util.DateHelper;

@Controller
public class ProjectController {
	
	private static final Log log = LogFactory.getLog(ProjectController.class);
	
	@Autowired
	UserService userService;

	@Autowired
	ProjectService projectService;

	@Autowired
	TaskService taskService;

	@Autowired
	SubTaskService subTaskService;

	@Autowired
	TicketService ticketService;

	@Autowired
	TaskMessageService taskMessageService;

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

	@RequestMapping(value = "/project/projectsList", method = RequestMethod.GET)
	public ModelAndView projectHome(HttpServletRequest request, HttpServletResponse response, Principal principal) {
		List<Project> projectList;
		Map<String, Object> myModel = new HashMap<String, Object>();

		if (principal != null) {
			CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
			User u = userService.findUserById(userDetails.getId());
			myModel.put("user", u);
			if (userDetails.getUserRole() == UserRole.ROLE_ADMIN) {
				projectList = projectService.getAllProjects();
			} else {
				projectList = projectService.getProjectsByUserId(u.getId());
			}
			myModel.put("projectList", projectList);

			List<ProjectProgressDTO> projectProgressList = new ArrayList<>();
			for (Project p : projectList) {
				p.setTasks(taskService.getTasksByProjectId(p.getId()));
				projectProgressList.add(new ProjectProgressDTO(p));
			}

			myModel.put("projectProgressList", projectProgressList);
		} else {
			// TODO redirect to login
			return new ModelAndView("accessDenied", null);
		}

		return new ModelAndView("project/projectsList", myModel);
	}

	// called when click on create new project
	@RequestMapping(value = "/project/edit", method = RequestMethod.GET)
	public ModelAndView addProject(HttpServletRequest request, HttpServletResponse response, Principal principal) {
		Map<String, Object> myModel = new HashMap<String, Object>();

		// TODO vérifier que c'est un manager
		// TODO validation des données, date de fin après le début
		if (principal != null) {
			Project project = new Project();
			CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
			User u = userService.findUserById(userDetails.getId());

			myModel.put("project", project);
			project.addUser(u);
			myModel.put("user", u);
			myModel.put("users", userService.getAllActiveUsers());
			myModel.put("groups", userService.getAllNonEmptyGroups());
		} else {
			return new ModelAndView("redirect:" + "/");
		}

		return new ModelAndView("project/editProject", myModel);
	}

	// call when click on corresponding edit button in projectList page
	@RequestMapping(value = "/project/edit/{projectId}", method = RequestMethod.GET)
	public ModelAndView editProject(@CurrentUserDetails CustomUserDetails userDetails, @PathVariable Long projectId) {
		Map<String, Object> myModel = new HashMap<String, Object>();

		if (userDetails == null) {
			return new ModelAndView("redirect:/");
		}

		Project project = projectService.findProjectById(projectId);

		if (project == null) {
			// TODO not found
			return new ModelAndView("redirect:/");
		}
		project.setUsers(projectService.getUsersByProjectId(project.getId()));
		myModel.put("project", project);
		myModel.put("user", userService.findUserById(userDetails.getId()));
		myModel.put("users", userService.getAllActiveUsers());
		myModel.put("groups", userService.getAllNonEmptyGroups());

		return new ModelAndView("project/editProject", myModel);
	}

	@RequestMapping(value = "/project/viewProject/{projectId}", method = RequestMethod.GET)
	public ModelAndView viewProject(@CurrentUserDetails CustomUserDetails userDetails, @PathVariable Long projectId) {
		Map<String, Object> myModel = new HashMap<String, Object>();

		if (userDetails == null) {
			return new ModelAndView("redirect:/");
		}

		Project project = projectService.findProjectById(projectId);

		if (project == null) {
			// TODO not found
			return new ModelAndView("redirect:/");
		}

		project.setUsers(projectService.getUsersByProjectId(project.getId()));
		project.setTasks(taskService.getTasksByProjectId(project.getId()));
		ProjectProgressDTO projectProgress = new ProjectProgressDTO(project);
		myModel.put("project", project);
		User user = userService.findUserById(userDetails.getId());
		
		List<Project> projects = null;
		if (user.getUserRole().equals(UserRole.ROLE_ADMIN))
			projects = projectService.getAllProjects();
		else
			projects = projectService.getProjectsByUserId(userDetails.getId());
		List<DataDTO> dataDTOProjects = new ArrayList<DataDTO>();
		for (Project p : projects) {
			dataDTOProjects.add(new DataDTO(p.getId(), p.getName()));
		}
		
		myModel.put("projects", dataDTOProjects);
		myModel.put("user", user);
		myModel.put("tickets", ticketService.getTicketsByProjectId(project.getId()));
		myModel.put("projectProgress", projectProgress);
		myModel.put("tasks", taskService.getTasksByProjectId(project.getId()));

		return new ModelAndView("project/projectView", myModel);
	}

	/* @RequestMapping(value = "/project/viewProject/{projectId}/tasks", method = RequestMethod.GET) public ModelAndView
	 * viewProjectTasks(@CurrentUserDetails CustomUserDetails userDetails, @PathVariable Long projectId) { Map<String, Object> myModel = new
	 * HashMap<String, Object>();
	 * 
	 * if (userDetails == null) { return new ModelAndView("redirect:/"); }
	 * 
	 * Project project = projectService.findProjectById(projectId);
	 * 
	 * if (project == null) { // TODO not found return new ModelAndView("redirect:/"); } myModel.put("project", project); myModel.put("tasks",
	 * taskService.getTasksByProjectId(project.getId())); myModel.put("user", userService.findUserById(userDetails.getId()));
	 * 
	 * return new ModelAndView("project/projectTasksView", myModel); } */

	@RequestMapping(value = "/project/viewProject/{projectId}/tasks/{taskId}", method = RequestMethod.GET)
	public ModelAndView viewProjectTaskBox(@CurrentUserDetails CustomUserDetails userDetails, @PathVariable Long projectId, @PathVariable Long taskId) {
		Map<String, Object> myModel = new HashMap<String, Object>();

		if (userDetails == null) {
			return new ModelAndView("redirect:/");
		}

		Project p = projectService.findProjectById(projectId);
		Task t = taskService.findTaskById(taskId);

		if (p == null || t == null)
			return new ModelAndView("redirect:/");

		p.setUsers(projectService.getUsersByProjectId(projectId));
		t.setProject(p);
		t.setUsers(taskService.getUsersByTaskId(taskId));
		List<TaskPriority> priorities = taskService.getAllTaskPriorities();

		myModel.put("task", t);
		myModel.put("priorities", priorities);
		myModel.put("user", userService.findUserById(userDetails.getId()));
		myModel.put("subTasks", subTaskService.getSubTasksByTaskIdAndFetchUserAndTask(t.getId()));
		myModel.put("taskMessages", taskMessageService.getTaskMessagesByTaskId(t.getId()));

		return new ModelAndView("project/taskBoxView", myModel);
	}

	@RequestMapping(value = "/project/save", method = RequestMethod.POST)
	public ModelAndView saveProject(Principal principal, @ModelAttribute("project") Project project, BindingResult result) {
		// CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
		if (principal != null) {
			long diff = project.getDateEnd().getTime() - project.getDateBegin().getTime();
			float duration = (float) diff / (24 * 60 * 60 * 1000);
			project.setDuration((long) Math.floor(duration));

			// project does not exist
			if (project.getId() == null) {
				project.setProgress(0l);
				project.setStatus(ProjectStatus.ACTIVE.getValue());
				projectService.saveProject(project);
			} else { // project exists
				Project p = projectService.findProjectById(project.getId());
				project.setProgress(p.getProgress());
				project.setStatus(p.getStatus());
				projectService.updateProject(project);
			}
		} else
			return new ModelAndView("redirect:/");

		return new ModelAndView("redirect:/project/projectsList");
	}

	@RequestMapping(value = "/project/delete", method = RequestMethod.POST)
	public ModelAndView deleteProject(Principal principal, @ModelAttribute("project") Project project, BindingResult result) {
		CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
		User u = userService.findUserById(userDetails.getId());

		if (principal != null && u.getUserRole().equals(UserRole.ROLE_ADMIN)) {
			try {
				projectService.deleteProjectById(project.getId());
			} catch (Exception e) {
				log.error("error deleting project", e);
			}
		} else
			return new ModelAndView("accessDenied");

		return new ModelAndView("redirect:/project/projectsList");
	}

	// We chose to authorize adding inactive users via group.
	// Called from edit project to fetch users of a given group
	@RequestMapping(value = "project/fetchGroupUsers", method = RequestMethod.GET)
	public @ResponseBody String fetchGroupUsers(Principal principal, @RequestParam("groupId") Long groupId) {
		List<User> users = new ArrayList<>();
		Gson gson = new GsonBuilder().excludeFieldsWithoutExposeAnnotation().create();
		try {
			users = userService.getGroupUsersByGroupId(groupId);
			String json = gson.toJson(users);

			return json;
		} catch (Exception e) {
			log.error("error while fetching group (group id: " + groupId + ")", e);
			return "KO";
		}
	}

	// We chose to authorize adding inactive users via group.
	// Called from edit/save task. It gets users found that are both in the current project and group
	@RequestMapping(value = "project/task/fetchGroupUsers", method = RequestMethod.GET)
	public @ResponseBody String fetchGroupUsersForTask(Principal principal,
													   @RequestParam("groupId") Long groupId,
													   @RequestParam("projectId") Long projectId) {
		List<User> users = new ArrayList<>();
		List<User> usersInProject = new ArrayList<>();
		Gson gson = new GsonBuilder().excludeFieldsWithoutExposeAnnotation().create();
		try {
			users = userService.getGroupUsersByGroupId(groupId);
			usersInProject = projectService.getUsersByProjectId(projectId);
			
			// getting list intersection
			users.retainAll(usersInProject);

			String json = gson.toJson(users);

			return json;
		} catch (Exception e) {
			log.error("error while fetching group id: " + groupId + " for project id " + projectId, e);
			return "KO";
		}
	}
	
	@RequestMapping(value = "project/createTask/{projectId}", method = RequestMethod.GET)
	public ModelAndView createTaskForProject(@CurrentUserDetails CustomUserDetails userDetails, @PathVariable Long projectId) {
		Map<String, Object> myModel = new HashMap<String, Object>();
		if (userDetails == null) {
			return new ModelAndView("redirect:/");
		}
		
		Project project = projectService.findProjectById(projectId);
		
		if (project == null) {
			// TODO not found
			return new ModelAndView("redirect:/");
		}
		List<User> users = projectService.getUsersByProjectId(project.getId());
		myModel.put("user", userService.findUserById(userDetails.getId()));
		myModel.put("users", users);

		project.setUsers(users);
		myModel.put("project", project);
		
		List<TaskPriority> priorities = taskService.getAllTaskPriorities();
		myModel.put("priorities", priorities);

		Task task = new Task();
		task.setStartingDate(new Date());
		task.setEndingDate(new Date());
		task.setPriority(new TaskPriority(Priority.LOW));
		myModel.put("task", task);
		
		myModel.put("groups", userService.getAllNonEmptyGroups());
		
		myModel.put("taskType", TaskLevel.TASK.getId());
		myModel.put("milestoneType", TaskLevel.MILESTONE.getId());
		
		return new ModelAndView("project/createTasks", myModel);
	}
	
	@RequestMapping(value = "/project/task/save", method = RequestMethod.POST)
	public ModelAndView saveTask(Principal principal, @ModelAttribute("task") Task task, BindingResult result) {
		//CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();		

		if (principal != null) {

			// task does not exist
			if (task.getId() == null) {
				task.setProgress(0l);
				task.setStatus("STATUS_UNDEFINED");
				task.setDuration(DateHelper.getDaysDuration(task.getStartingDate(), task.getEndingDate()));
				task.setRow(taskService.findMaxTaskRowByProjectId(task.getProject().getId()));
				
				try {
					taskService.saveTask(task);
				}
				catch (Exception e) {
					log.error("error saving task: ", e);
					return new ModelAndView("redirect:/");
				}
			}
			// Else edit Task
		}
		else
			return new ModelAndView("redirect:/");

		return new ModelAndView("redirect:/project/createTask/" + task.getProject().getId());
	}
}
