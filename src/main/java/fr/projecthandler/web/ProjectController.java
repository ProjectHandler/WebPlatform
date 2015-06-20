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

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomCollectionEditor;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.ServletRequestDataBinder;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import fr.projecthandler.model.Project;
import fr.projecthandler.model.User;
import fr.projecthandler.service.ProjectService;
import fr.projecthandler.service.UserService;
import fr.projecthandler.session.CustomUserDetails;

@Controller
public class ProjectController {
	@Autowired
	UserService userService;

	@Autowired
	ProjectService projectService;

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

	@RequestMapping(value = "/project/projectHome", method = RequestMethod.GET)
	public ModelAndView projectHome(HttpServletRequest request,
			HttpServletResponse response, Principal principal) {
		Map<String, Object> myModel = new HashMap<String, Object>();

		if (principal != null) {
			CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal)
					.getPrincipal();
			User u = userService.findUserById(userDetails.getId());

			myModel.put("user", u);
			List<Project> projectList = projectService.getProjectsByUserId(u
					.getId());
			myModel.put("projectList", projectList);
		} else {
			// TODO redirect to login
			return new ModelAndView("accessDenied", null);
		}

		return new ModelAndView("project/projectHome", myModel);
	}

	@RequestMapping(value = "/project/new", method = RequestMethod.GET)
	public ModelAndView addProject(HttpServletRequest request,
			HttpServletResponse response, Principal principal) {
		Map<String, Object> myModel = new HashMap<String, Object>();

		// TODO vérifier que c'est un manager
		// TODO validation des données, date de fin après le début
		if (principal != null) {
			Project project = new Project();
			CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal)
					.getPrincipal();

			project.setDateBegin(new Date());
			project.setDateEnd(new Date());
			myModel.put("project", project);
			myModel.put("user", userService.findUserById(userDetails.getId()));
			myModel.put("users", userService.getAllActiveUsers());
			myModel.put("groups", userService.getAllNonEmptyGroups());
		} else {
			return new ModelAndView("redirect:" + "/");
		}

		return new ModelAndView("project/addProject", myModel);
	}

	@RequestMapping(value = "/project/save", method = RequestMethod.POST)
	public ModelAndView saveProject(Principal principal,
			@ModelAttribute("project") Project project, BindingResult result) {
		if (principal != null) {

			long diff = project.getDateEnd().getTime()
					- project.getDateBegin().getTime();
			float duration = (float) diff / (24 * 60 * 60 * 1000);
			project.setDuration((long) Math.floor(duration));
			project.setProgress(0l);
			project.setStatus("STATUS_ACTIVE");

			projectService.saveProject(project);
		} else {
			return new ModelAndView("redirect:" + "/");
		}

		return new ModelAndView("redirect:" + "/project/projectHome");
	}
	
	// We chose to authorize adding inactive users via group.
	@RequestMapping(value = "project/fetchGroupUsers", method = RequestMethod.GET)
	public @ResponseBody String fetchGroupUsers(Principal principal, @RequestParam("groupId") String groupId) {
		List<User> users = new ArrayList<>();
		Gson gson = new GsonBuilder().excludeFieldsWithoutExposeAnnotation().create();
		try {
			users = userService.getGroupUsersByGroupId(Long.parseLong(groupId));
			String json = gson.toJson(users);
			
			return json;
		} catch (Exception e) {
			e.printStackTrace();
			return "KO";
		}
	}
}
