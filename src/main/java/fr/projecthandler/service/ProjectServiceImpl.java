package fr.projecthandler.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import fr.projecthandler.dao.ProjectDao;
import fr.projecthandler.model.Project;
import fr.projecthandler.model.Task;
import fr.projecthandler.model.Ticket;
import fr.projecthandler.model.User;

@Service
public class ProjectServiceImpl implements ProjectService {

	@Autowired
	ProjectDao projectDao;
	
	@Autowired
	TicketService ticketService;
	
	@Autowired
	TaskService taskService;

	@Override
	public Long saveProject(Project newProject) {
		return projectDao.saveProject(newProject);
	}

	@Override
	public void updateProject(Project a) {
		projectDao.updateProject(a);
	}

	@Override
	public Project findProjectById(Long id) {
		return projectDao.findProjectById(id);
	}

	@Override
	public void deleteProjectsByIds(List<Long> projectIds) {
		projectDao.deleteProjectsByIds(projectIds);
	}

	@Override
	public List<Project> getAllProjects() {
		return projectDao.getAllProjects();
	}

	@Override
	public List<Project> getProjectsByUserId(Long userId) {
		return projectDao.getProjectsByUserId(userId);
	}

	@Override
	public void deleteProjectById(Long projectId) {
		if (projectId != null) {
			Project p = findProjectById(projectId);
			p.setTasks(taskService.getTasksByProjectId(projectId));
			p.setUsers(getUsersByProjectId(projectId));
			List<Long> tasksIds = new ArrayList<Long>();
			for (Task t : p.getTasks()) {
				tasksIds.add(t.getId());
			}
			taskService.deleteTasksByIds(tasksIds);
			List<Ticket> tickets = ticketService.getTicketsByProjectId(projectId);
			List<Long> ticketsIdsList = new ArrayList<Long>();
			for(Ticket t : tickets) {
				ticketsIdsList.add(t.getId());
			}
			ticketService.deleteTicketsByIds(ticketsIdsList);
			projectDao.deleteProjectById(projectId);
		}
	}

	@Override
	public Project loadGantt(Long projectId) {
		return projectDao.findProjectById(projectId);
	}
	
	@Override
	public List<User> getUsersByProjectId(Long projectId) {
		return projectDao.getUsersByProjectId(projectId);
	}
}
