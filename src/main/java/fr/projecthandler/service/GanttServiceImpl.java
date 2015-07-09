package fr.projecthandler.service;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.lang3.StringUtils;
import org.codehaus.jackson.map.ObjectMapper;
import org.codehaus.jackson.map.ObjectWriter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.google.gson.Gson;

import fr.projecthandler.dto.GanttAssigsDTO;
import fr.projecthandler.dto.GanttProjectDTO;
import fr.projecthandler.dto.GanttResourceDTO;
import fr.projecthandler.dto.GanttTaskDTO;
import fr.projecthandler.model.Project;
import fr.projecthandler.model.Task;
import fr.projecthandler.model.User;

@Service
public class GanttServiceImpl implements GanttService {

	@Autowired
	UserService userService;

	@Autowired
	ProjectService projectService;

	@Autowired
	TaskService taskService;
		
	@Override
	public String load(Long projectId) {
		try {
			ObjectWriter ow = new ObjectMapper().writer().withDefaultPrettyPrinter();
			return ow.writeValueAsString(loadProject(projectId));
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}

	private GanttProjectDTO loadProject(Long projectId) {
		Project project = projectService.loadGantt(projectId);
		GanttProjectDTO prorojectDTO = new GanttProjectDTO();
		List<GanttTaskDTO> listTaskDTO = new ArrayList<GanttTaskDTO>();
		listTaskDTO.add(new GanttTaskDTO(project));
		listTaskDTO.addAll(loadTasks(projectId));
		prorojectDTO.setTasks(listTaskDTO);
		prorojectDTO.setResources(loadProjectResources(projectId));
		
		return prorojectDTO;
	}
	
	private List<GanttTaskDTO> loadTasks(Long projectId) {
		List<GanttTaskDTO> listTaskDTO = new ArrayList<GanttTaskDTO>();
		Set<Task> tasks = taskService.getTasksByProjectId(projectId);
		
		if (tasks != null) {		
			Map<Long, Integer> rowId = new HashMap<Long, Integer>();
			Integer row = 2;//1 = project
			for (Task t : tasks) {
				rowId.put(t.getId(), row);
				++row;

			
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

				gt.setAssigs(loadTaskResources(t.getId()));
				listTaskDTO.add(gt);
			}
		}
		return listTaskDTO;
	}
	
	private List<GanttResourceDTO> loadProjectResources(Long projectId) {
		List<GanttResourceDTO> listResources = new ArrayList<GanttResourceDTO>();
		List<User> users = projectService.getUsersByProjectId(projectId);
		for (User user : users)
			listResources.add(new GanttResourceDTO(user));
		return listResources;
	}
	
	private List<GanttAssigsDTO> loadTaskResources(Long taskId) {
		List<GanttAssigsDTO> listAssigsDTO = new ArrayList<GanttAssigsDTO>();
		List<User> users = taskService.getUsersByTaskId(taskId);
		for (User user : users) {
			GanttAssigsDTO assigs = new GanttAssigsDTO();
			assigs.setId(user.getId().toString());
			assigs.setResourceId(user.getId().toString());
			listAssigsDTO.add(assigs);
		}
		return listAssigsDTO;
	}
	
	@Override
	public void save(String ganttGson) {

		Gson gson = new Gson();
		final GanttProjectDTO prj = gson.fromJson(ganttGson, GanttProjectDTO.class);
		
		List<Task> lstTask = new ArrayList<Task>();
		List<GanttTaskDTO> listTaskDTO = prj.getTasks();
		Map<Integer, Long> rowId = new HashMap<Integer, Long>();
		
		for (GanttTaskDTO taskDTO : listTaskDTO) {
			if (taskDTO.getId().startsWith("project_"))
				taskDTO.setId(taskDTO.getId().substring(8, taskDTO.getId().length()));
			else if (taskDTO.getId().startsWith("task_"))
				taskDTO.setId(taskDTO.getId().substring(5,  taskDTO.getId().length()));
		}
		
		Project newProject = saveProjectAndTask(lstTask, listTaskDTO, rowId);
		saveDependsTasks(listTaskDTO, rowId);
		saveDeletedTask(prj);
		
		Set<Task> setTasks = new HashSet<Task>();
		setTasks.addAll(lstTask);
		newProject.setTasks(setTasks);
		
		saveUsersOnProject(prj, newProject);
		projectService.updateProject(newProject);
	}
		
	private Project saveProjectAndTask(List<Task> lstTask, List<GanttTaskDTO> listTaskDTO, Map<Integer, Long> rowId) {
		Project newProject = null;
		int row = 0;
		for (GanttTaskDTO taskDTO : listTaskDTO) {
			
			if (taskDTO.getLevel() == 0) { // project
				newProject = new Project(taskDTO);
			} else {
				Task t = new Task(taskDTO);
				t.setProject(newProject);
				t.setUsers(saveUsersOnTask(taskDTO));
				t.setRow((long) (row + 1));

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
		return newProject;
	}
	
	private void saveDependsTasks(List<GanttTaskDTO> listTaskDTO, Map<Integer, Long> rowId) {
		
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
	}
	
	private void saveDeletedTask(GanttProjectDTO prj) {
		for (String taskId : prj.getDeletedTaskIds()) {
			if (taskId.startsWith("task_"))
				taskService.deleteTasksByIds(Arrays.asList(Long.parseLong(taskId.substring(5,  taskId.length()))));
			else
				taskService.deleteTasksByIds(Arrays.asList(Long.parseLong(taskId)));
		}
	}
	
	private void saveUsersOnProject(GanttProjectDTO projectDTO, Project project) {
		List<GanttResourceDTO> listResource = projectDTO.getResources();
		
		for (GanttResourceDTO resourceDTO : listResource) {
			User user = userService.findUserById(Long.parseLong(resourceDTO.getId()));
			if (user != null)
				project.addUser(user);
		}
	}
	
	private List<User> saveUsersOnTask(GanttTaskDTO taskDTO) {
		List<GanttAssigsDTO> listAssigsDTO = taskDTO.getAssigs();
		List<User> listUsers = new ArrayList<User>();
		
		for (GanttAssigsDTO assigsDTO : listAssigsDTO) {
			assigsDTO.getResourceId();
			User user = userService.findUserById(Long.parseLong(assigsDTO.getResourceId()));
			if (user != null)
				listUsers.add(user);
		}
		return listUsers;
	}
}
