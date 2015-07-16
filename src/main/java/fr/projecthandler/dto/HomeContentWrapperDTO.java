package fr.projecthandler.dto;
import java.util.Date;

import fr.projecthandler.enums.TaskLevel;
import fr.projecthandler.model.Event;
import fr.projecthandler.model.Task;

public class HomeContentWrapperDTO {
	private Long id;
	private String type;
	private String name;
	private String description;
	private Date startingDate;
	private Date endingDate;
	private String status;
	private Long progress;
	
	public HomeContentWrapperDTO(Event e) {
		id = e.getId();
		type = TaskLevel.EVENT.getValue();
		name = e.getTitle();
		description = e.getDescription();
		startingDate = e.getStartingDate();
		endingDate = e.getEndingDate();
		status = e.getStatus();
		progress = 0l;
	}
	
	public HomeContentWrapperDTO(Task t) {
		id = t.getId();
		type = TaskLevel.TASK.getValue();
		name = t.getName();
		description = t.getDescription();
		startingDate = t.getStartingDate();
		endingDate = t.getEndingDate();
		status = t.getStatus();
		progress = t.getProgress();
	}
	
	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public Date getStartingDate() {
		return startingDate;
	}

	public void setStartingDate(Date startingDate) {
		this.startingDate = startingDate;
	}

	public Date getEndingDate() {
		return endingDate;
	}

	public void setEndingDate(Date endingDate) {
		this.endingDate = endingDate;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public Long getProgress() {
		return progress;
	}

	public void setProgress(Long progress) {
		this.progress = progress;
	}
	
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result
				+ ((endingDate == null) ? 0 : endingDate.hashCode());
		result = prime * result + ((id == null) ? 0 : id.hashCode());
		result = prime * result + ((name == null) ? 0 : name.hashCode());
		result = prime * result
				+ ((startingDate == null) ? 0 : startingDate.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		HomeContentWrapperDTO other = (HomeContentWrapperDTO) obj;
		if (endingDate == null) {
			if (other.endingDate != null)
				return false;
		} else if (!endingDate.equals(other.endingDate))
			return false;
		if (id == null) {
			if (other.id != null)
				return false;
		} else if (!id.equals(other.id))
			return false;
		if (name == null) {
			if (other.name != null)
				return false;
		} else if (!name.equals(other.name))
			return false;
		if (startingDate == null) {
			if (other.startingDate != null)
				return false;
		} else if (!startingDate.equals(other.startingDate))
			return false;
		return true;
	}
}
