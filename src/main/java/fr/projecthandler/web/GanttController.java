package fr.projecthandler.web;

import java.security.Principal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.map.ObjectWriter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.google.gson.JsonParser;

import fr.projecthandler.dto.GanttProjectDTO;
import fr.projecthandler.dto.GanttTaskDTO;
import fr.projecthandler.model.Project;
import fr.projecthandler.model.Task;
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
	HttpSession httpSession;

	@RequestMapping(value = "/gantt", method = RequestMethod.GET)
	public ModelAndView gantt() {

		Map<String, Object> myModel = new HashMap<String, Object>();
		myModel.put("projects", projectService.getAllProjects());

		return new ModelAndView("gantt/gantt", myModel);
	}

	@RequestMapping(value = "/gantt/load", method = RequestMethod.POST)
	public @ResponseBody Object loadGantt(HttpServletRequest request, Principal principal) {
		try {
			Long id = Long.parseLong(request.getParameter("projectId"), 10);
			Project project = projectService.loadGantt(id);
			GanttTaskDTO projDTO = new GanttTaskDTO(project);
			GanttProjectDTO prorojectDTO = new GanttProjectDTO();
			List<GanttTaskDTO> listTaskDTO = new ArrayList<GanttTaskDTO>();
			listTaskDTO.add(projDTO);

			Set<Task> tasks = taskService.getTasksByProjectId(id);
			for (Task t : tasks) {
				GanttTaskDTO gt = new GanttTaskDTO(t);
				listTaskDTO.add(gt);
			}

			prorojectDTO.setTasks(listTaskDTO);

			ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
			String json = null;

			json = ow.writeValueAsString(prorojectDTO);

			return new JsonParser().parse(json);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	@RequestMapping(value = "/gantt/save", method = RequestMethod.POST)
	public void saveGantt(HttpServletRequest request, Principal principal) {
		Gson gson = new Gson();
		final GanttProjectDTO prj = gson.fromJson(request.getParameter("prj"), GanttProjectDTO.class);

		List<Task> lstTask = new ArrayList<Task>();
		Project newProject = null;
		List<GanttTaskDTO> listTaskDTO = prj.getTasks();

		for (GanttTaskDTO taskDTO : listTaskDTO) {
			if (taskDTO.getLevel() == 0) { // project
				newProject = new Project(taskDTO);
			} else {
				Task t = new Task(taskDTO);
				t.setProject(newProject);

				if (taskDTO.getId().startsWith("tmp")) {
					taskService.saveTask(t);
				}
				taskService.updateTask(t);
				lstTask.add(t);
			}
		}

		Set<Task> oldTasks = taskService.getTasksByProjectId(newProject.getId());
		for (Task old : oldTasks) {
			if (!lstTask.contains(old))
				taskService.deleteTasksByIds(Arrays.asList(old.getId()));
		}

		Set<Task> setTasks = new HashSet<>();
		setTasks.addAll(lstTask);
		newProject.setTasks(setTasks);
		projectService.updateProject(newProject);
	}
}
