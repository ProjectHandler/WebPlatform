package fr.projecthandler.dto;

import java.util.Date;
import java.util.Set;

import fr.projecthandler.enums.TaskLevel;
import fr.projecthandler.model.Project;
import fr.projecthandler.model.Task;

public class ProjectProgressDTO {
	private Long projectId;
	private Integer dateProgress;
	private Integer daysLeft;
	private Integer tasksProgress;
	
	public ProjectProgressDTO(Project p) {
		projectId = p.getId();
		computeDateProgress(p.getDateBegin(), p.getDateEnd());
		computeTaskProgress(p.getTasks());
	}
	
	private void computeDateProgress(Date begin, Date end) {
		Date curr = new Date();
		long dayInMs = 86400000;
		double totalTime = end.getTime() - begin.getTime();
		double elapsedTime = Math.min(curr.getTime(), end.getTime())- begin.getTime();

		this.daysLeft = (int)((totalTime - elapsedTime) / dayInMs);

		if (this.daysLeft < 0) {
			this.dateProgress = 100;
			this.daysLeft = 0;
		}
		else {
			this.dateProgress = (int)Math.round((elapsedTime / totalTime) * 100);
		}
	}
	
	private void computeTaskProgress(Set<Task> tasks) {
		if (!tasks.isEmpty()) {
			double count = 0;
			double done = 0;
			for (Task t : tasks) {
				if (t.getLevel() == TaskLevel.TASK.getId()) {
					count++;
					if (t.getStatus().equals("STATUS_DONE"))
						done++;
				}
				
			}
			this.tasksProgress = (int)Math.round((done / count) * 100);
		}
		else
			this.tasksProgress = 100;
	}

	public Long getProjectId() {
		return projectId;
	}

	public void setProjectId(Long projectId) {
		this.projectId = projectId;
	}

	public Integer getDateProgress() {
		return dateProgress;
	}

	public void setDateProgress(Integer dateProgress) {
		this.dateProgress = dateProgress;
	}

	public Integer getDaysLeft() {
		return daysLeft;
	}

	public void setDaysLeft(Integer daysLeft) {
		this.daysLeft = daysLeft;
	}

	public Integer getTasksProgress() {
		return tasksProgress;
	}

	public void setTasksProgress(Integer tasksProgress) {
		this.tasksProgress = tasksProgress;
	}
}
