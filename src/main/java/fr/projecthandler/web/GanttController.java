package fr.projecthandler.web;

import java.security.Principal;
import java.util.ArrayList;
import java.util.List;

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

import com.google.gson.JsonParser;

import fr.projecthandler.dto.GanttProjectDTO;
import fr.projecthandler.dto.GanttTaskDTO;
import fr.projecthandler.model.Project;
import fr.projecthandler.service.ProjectService;
import fr.projecthandler.service.UserService;

@Controller
public class GanttController {

	@Autowired
	UserService userService;

	@Autowired
	ProjectService projectService;

	@Autowired
	HttpSession httpSession;
	
	@RequestMapping(value = "/gantt", method = RequestMethod.GET)
	public ModelAndView gantt() {
		return new ModelAndView("gantt/gantt");
	}
	
	@RequestMapping(value = "/gantt/load", method = RequestMethod.POST)
	public @ResponseBody Object loadGantt(HttpServletRequest request, Principal principal) {
		try {
			Project project = projectService.loadGantt(Long.parseLong(request.getParameter("projectId"), 10));
			GanttTaskDTO taskDTO = new GanttTaskDTO(project);
			GanttProjectDTO prorojectDTO = new GanttProjectDTO();
			List<GanttTaskDTO> listTaskDTO = new ArrayList<GanttTaskDTO>();
			listTaskDTO.add(taskDTO);
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
}
