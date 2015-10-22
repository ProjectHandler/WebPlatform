package fr.projecthandler.web;

import java.security.Principal;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.JsonElement;
import com.google.gson.JsonParser;

import fr.projecthandler.enums.UserRole;
import fr.projecthandler.service.GanttService;
import fr.projecthandler.service.ProjectService;
import fr.projecthandler.service.TaskService;
import fr.projecthandler.service.UserService;
import fr.projecthandler.session.CustomUserDetails;
import fr.projecthandler.util.Utilities;

@Controller
public class GanttController {

	@Autowired
	UserService userService;

	@Autowired
	ProjectService projectService;

	@Autowired
	TaskService taskService;

	@Autowired
	GanttService ganttService;

	@Autowired
	HttpSession httpSession;

	@RequestMapping(value = "/gantt", method = RequestMethod.GET)
	public ModelAndView gantt(Principal principal) {
		CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
		Map<String, Object> myModel = new HashMap<String, Object>();
		
		if (userDetails.getUserRole() == UserRole.ROLE_ADMIN)
			myModel.put("projects", projectService.getAllProjects());
		else
			myModel.put("projects", projectService.getProjectsByUserId(userDetails.getId()));

		myModel.put("users", userService.getAllUsers());
		return new ModelAndView("gantt/gantt", myModel);
	}

	@RequestMapping(value = "/gantt/load", method = RequestMethod.POST)
	public @ResponseBody Object loadGantt(HttpServletRequest request, Principal principal) {
		JsonElement jsonElement = null;
		try {
			String projectId = Utilities.getRequestParameter(request, "projectId");
			if (projectId != null) {
				String json = ganttService.load(Long.parseLong(projectId));
				jsonElement = new JsonParser().parse(json);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return jsonElement;
	}

	@RequestMapping(value = "/gantt/save", method = RequestMethod.POST)
	public @ResponseBody String saveGantt(HttpServletRequest request, Principal principal) {
		try {
			ganttService.save(request.getParameter("prj"));
			return "success";
		} catch (Exception e) {
			e.printStackTrace();
			return "error";
		}
	}
}
