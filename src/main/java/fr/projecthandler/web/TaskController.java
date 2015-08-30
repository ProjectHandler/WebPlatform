package fr.projecthandler.web;

import java.security.Principal;
import java.util.List;

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

import fr.projecthandler.model.Task;
import fr.projecthandler.model.TaskPriority;
import fr.projecthandler.service.ProjectService;
import fr.projecthandler.service.TaskService;
import fr.projecthandler.service.TicketService;
import fr.projecthandler.service.UserService;

@Controller
public class TaskController {
	@Autowired
	UserService userService;

	@Autowired
	ProjectService projectService;
	
	@Autowired
	TaskService taskService;

	@Autowired
	TicketService ticketService;

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
	public @ResponseBody String changePriority(Principal principal, @RequestParam("taskId") Long taskId, @RequestParam("priorityId") Long priority) {
		System.out.println("priority=" + priority);
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
				return "KO";
			}
		}
		return "OK";
	}
}
