package fr.projecthandler.formatter;

import java.text.ParseException;
import java.util.Locale;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.Formatter;
import org.springframework.stereotype.Component;

import fr.projecthandler.model.Project;
import fr.projecthandler.service.ProjectService;

@Component
public class ProjectFormatter implements Formatter<Project> {

	@Autowired
	private ProjectService projectService;
	
    @Override
    public String print(Project project, Locale locale) {
        return project.getId().toString();
    }

    @Override
    public Project parse(String projectId, Locale locale) throws ParseException {
        return projectService.findProjectById(Long.parseLong(projectId));
    }
}
