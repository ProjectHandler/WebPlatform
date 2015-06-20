package fr.projecthandler.web;

import java.security.Principal;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.JsonParser;

import fr.projecthandler.service.GanttService;
import fr.projecthandler.service.ProjectService;
import fr.projecthandler.service.TaskService;
import fr.projecthandler.service.UserService;

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
	public ModelAndView gantt() {

		Map<String, Object> myModel = new HashMap<String, Object>();
		myModel.put("projects", projectService.getAllProjects());
		myModel.put("users", userService.getAllUsers());
		return new ModelAndView("gantt/gantt", myModel);
	}

	@RequestMapping(value = "/gantt/load", method = RequestMethod.POST)
	public @ResponseBody Object loadGantt(HttpServletRequest request, Principal principal) {
		String json =  ganttService.load(Long.parseLong(request.getParameter("projectId"), 10));
		return new JsonParser().parse(json);
	}

	@RequestMapping(value = "/gantt/save", method = RequestMethod.POST)
	public void saveGantt(HttpServletRequest request, Principal principal) {
		ganttService.save(request.getParameter("prj"));
	}
}
