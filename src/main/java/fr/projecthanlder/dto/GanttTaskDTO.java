package fr.projecthanlder.dto;

import java.util.ArrayList;
import java.util.List;

import fr.projecthandler.model.Project;
import fr.projecthandler.model.Task;

public class GanttTaskDTO {

	private String id;
	private String name;
	private String code;
	private long level;
	private String status;
	private long start;
	private long duration;
	private long end;
	private boolean startIsMilestone;
	private boolean endIsMilestone;
	private List<String> assigs;
	private String depends;
	private String description;
	private long progress;
	
	public GanttTaskDTO() {
	}
	
	public GanttTaskDTO(Project t) {
		this.id = t.getId().toString();
		this.name = t.getName();
		this.code = "";
		this.level = 0l;
		this.status = "STATUS_ACTIVE";
		this.start = t.getDateBegin().getTime();
		this.duration = 80l;
		//The end date is always recomputed using “start” and “duration”
		this.end = t.getDateEnd() == null ? 0 : t.getDateEnd().getTime();
		this.startIsMilestone = false;
		this.endIsMilestone = false;
		this.assigs = new ArrayList<String>();
		this.depends = "";
		this.description = t.getDescription();
		this.progress = 0l;
	}
	
	public GanttTaskDTO(Task t) {
		
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
	public String getDepends() {
		return depends;
	}
	public void setDepends(String depends) {
		this.depends = depends;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public long getProgress() {
		return progress;
	}
	public void setProgress(long progress) {
		this.progress = progress;
	}
	
	
}
