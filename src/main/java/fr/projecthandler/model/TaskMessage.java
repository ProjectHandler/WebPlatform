package fr.projecthandler.model;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import com.google.gson.annotations.Expose;

import fr.projecthandler.util.Utilities;

@Entity
@Table(name = "task_messages")
public class TaskMessage extends BaseEntity implements java.io.Serializable {

	private static final long serialVersionUID = 8440604918049912703L;

	@Expose
	@Column(name = "content", length = 200)
	private String content;

	@Expose
	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "user_id")
	private User owner;

	@Expose
	@Column(name = "update_date")
	private Date updateDate;

	@Expose
	@OneToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "task_id")
	private Task task;

	public TaskMessage() {
	}

	public TaskMessage(String content, User owner, Date updateDate, Task task) {
		this.content = Utilities.truncate(content, 200);
		this.owner = owner;
		this.updateDate = updateDate;
		this.task = task;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = Utilities.truncate(content, 200);
	}

	public User getOwner() {
		return owner;
	}

	public void setOwner(User owner) {
		this.owner = owner;
	}

	public Date getUpdateDate() {
		return updateDate;
	}

	public void setUpdateDate(Date updateDate) {
		this.updateDate = updateDate;
	}

	public Task getTask() {
		return task;
	}

	public void setTask(Task task) {
		this.task = task;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = super.hashCode();
		result = prime * result + ((content == null) ? 0 : content.hashCode());
		result = prime * result + ((updateDate == null) ? 0 : updateDate.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (!super.equals(obj))
			return false;
		if (getClass() != obj.getClass())
			return false;
		TaskMessage other = (TaskMessage) obj;
		if (content == null) {
			if (other.content != null)
				return false;
		} else if (!content.equals(other.content))
			return false;
		if (owner == null) {
			if (other.owner != null)
				return false;
		} else if (!owner.equals(other.owner))
			return false;
		if (task == null) {
			if (other.task != null)
				return false;
		} else if (!task.equals(other.task))
			return false;
		if (updateDate == null) {
			if (other.updateDate != null)
				return false;
		} else if (!updateDate.equals(other.updateDate))
			return false;
		return true;
	}
}
