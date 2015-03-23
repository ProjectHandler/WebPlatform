package fr.projecthandler.dto;

import java.util.ArrayList;
import java.util.List;

import fr.projecthandler.model.Project;
import fr.projecthandler.model.Task;

public class GanttTaskDTO {

	private String id;
	private String name;
	private long progress;
	private String description;
	private String code;
	private long level;
	private String status;
	private String depends;
	private boolean canWrite;
	private long start;
	private long duration;
	private long end;
	private boolean startIsMilestone;
	private boolean endIsMilestone;
	private List<String> assigs;
	private boolean hasChild;
	
	public GanttTaskDTO() {
	}
	
	public GanttTaskDTO(Project project) {
		this.id = project.getId().toString();
		this.name = project.getName();
		this.code = "";
		this.level = 0;
		this.status = "STATUS_ACTIVE";
		this.start = project.getDateBegin().getTime();
		this.canWrite = true;
		this.duration = project.getDuration();
		//The end date is always recomputed using “start” and “duration”
		this.end = project.getDateEnd() == null ? 0 : project.getDateEnd().getTime();
		this.startIsMilestone = false;
		this.endIsMilestone = false;
		this.assigs = new ArrayList<String>();
		this.depends = "";
		this.description = project.getDescription();
		this.progress = 0l;
	}
	
	public GanttTaskDTO(Task task) {
		this.id = task.getId().toString();
		this.name = task.getName();
		this.code = "";
		this.level = task.getLevel() + 1;
		this.status = "STATUS_ACTIVE";
		this.canWrite = true;
		this.start = task.getStartingDate() == null ? 0 : task.getStartingDate().getTime();
		this.duration = task.getDuration();
		//The end date is always recomputed using “start” and “duration”
		this.end = task.getEndingDate() == null ? 0 : task.getEndingDate().getTime();
		this.startIsMilestone = false;
		this.endIsMilestone = false;
		this.assigs = new ArrayList<String>();
		this.depends = "";
		this.description = task.getDescription();
		this.progress = task.getProgress();
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public long getProgress() {
		return progress;
	}

	public void setProgress(long progress) {
		this.progress = progress;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public long getLevel() {
		return level;
	}

	public void setLevel(long level) {
		this.level = level;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getDepends() {
		return depends;
	}

	public void setDepends(String depends) {
		this.depends = depends;
	}

	public boolean isCanWrite() {
		return canWrite;
	}

	public void setCanWrite(boolean canWrite) {
		this.canWrite = canWrite;
	}

	public long getStart() {
		return start;
	}

	public void setStart(long start) {
		this.start = start;
	}

	public long getDuration() {
		return duration;
	}

	public void setDuration(long duration) {
		this.duration = duration;
	}

	public long getEnd() {
		return end;
	}

	public void setEnd(long end) {
		this.end = end;
	}

	public boolean isStartIsMilestone() {
		return startIsMilestone;
	}

	public void setStartIsMilestone(boolean startIsMilestone) {
		this.startIsMilestone = startIsMilestone;
	}

	public boolean isEndIsMilestone() {
		return endIsMilestone;
	}

	public void setEndIsMilestone(boolean endIsMilestone) {
		this.endIsMilestone = endIsMilestone;
	}

	public List<String> getAssigs() {
		return assigs;
	}

	public void setAssigs(List<String> assigs) {
		this.assigs = assigs;
	}

	public boolean isHasChild() {
		return hasChild;
	}

	public void setHasChild(boolean hasChild) {
		this.hasChild = hasChild;
	}
	
	
}
