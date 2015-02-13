package fr.projecthandler.web;

import java.security.Principal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

import fr.projecthandler.model.Project;
import fr.projecthandler.model.User;
import fr.projecthandler.service.UserService;
import fr.projecthandler.session.CustomUserDetails;

@Controller
public class ProjectController {
	@Autowired
	UserService userService;

	@Autowired
	HttpSession httpSession;

	@RequestMapping(value = "project/projectHome", method = RequestMethod.GET)
	public ModelAndView projectHome(HttpServletRequest request, HttpServletResponse response, Principal principal) {
		Map<String, Object> myModel = new HashMap<String, Object>();

		if (principal != null) {
			CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
			User u = userService.findUserById(userDetails.getId());

			myModel.put("user", u);
			List<Project> projectList = userService.findAllProjectByUserId(u.getId());
			myModel.put("projectList", projectList);
			
			System.out.println("Projects:");
			for (Project project : projectList) {
				System.out.println("name: " + project.getName());
			}
		} else {
			// TODO redirect to login
			return new ModelAndView("accessDenied", null);
		}

		return new ModelAndView("project/projectHome", myModel);
	}
}
