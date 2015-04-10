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

import org.apache.commons.lang3.StringUtils;
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
			if (tasks != null) {		
				Map<Long, Integer> rowId = new HashMap<Long, Integer>();
				Integer row = 2;//1 = project
				for (Task t : tasks) {
					rowId.put(t.getId(), row);
					++row;
				}	
				
				for (Task t : tasks) {
					GanttTaskDTO gt = new GanttTaskDTO(t);
					
					Set<Task> depends = taskService.getTasksByProjectIdWithDepends(t.getId());
					StringBuilder sb = new StringBuilder();
					for (Task depend : depends)
						sb.append(rowId.get(depend.getId()).toString() + ",");
					if (sb.length() != 0)
						gt.setDepends(sb.substring(0, sb.length()-1));
					else
						gt.setDepends("");

					listTaskDTO.add(gt);
				}
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
		System.out.println(request.getParameter("prj"));
		Gson gson = new Gson();
		final GanttProjectDTO prj = gson.fromJson(request.getParameter("prj"), GanttProjectDTO.class);

		List<Task> lstTask = new ArrayList<Task>();
		Project newProject = null;
		List<GanttTaskDTO> listTaskDTO = prj.getTasks();

		Map<Integer, Long> rowId = new HashMap<Integer, Long>();
		int row = 0;
		for (GanttTaskDTO taskDTO : listTaskDTO) {
			System.out.println("task: " +  taskDTO.getName());
			
			if (taskDTO.getLevel() == 0) { // project
				newProject = new Project(taskDTO);
			} else {
				Task t = new Task(taskDTO);
				t.setProject(newProject);

				if (taskDTO.getId().startsWith("tmp")) {
					taskService.saveTask(t);
					taskDTO.setId(t.getId().toString());
				} else {
					t.setId(Long.parseLong(taskDTO.getId(), 10));
					taskService.updateTask(t);
				}
				rowId.put(row, t.getId());
				lstTask.add(t);
			}
			++row;
		}

		for (GanttTaskDTO taskDTO : listTaskDTO) {
			if (taskDTO.getLevel() != 0) {
				String depends = taskDTO.getDepends();
				Set<Task> depend = new HashSet<Task>();
				
				if (StringUtils.isEmpty(depends) == false) {
					String[] tokens = depends.split(",");
					if (tokens.length !=0) {
						for (String s : tokens) {
							int rowNb = Integer.parseInt(s);
							depend.add(taskService.findTaskById(rowId.get(rowNb-1)));
						}
					}
					else {
						depend.add(taskService.findTaskById(Long.parseLong(depends)));
					}
				}
				Task updateTask = taskService.findTaskById((Long.parseLong(taskDTO.getId())));
				updateTask.setDepend(depend);
				taskService.updateTask(updateTask);
			}
		}
		
		for (String taskId : prj.getDeletedTaskIds())
			taskService.deleteTasksByIds(Arrays.asList(Long.parseLong(taskId)));
		
		Set<Task> setTasks = new HashSet<Task>();
		setTasks.addAll(lstTask);
		newProject.setTasks(setTasks);
		projectService.updateProject(newProject);
	}
}
