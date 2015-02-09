package fr.projecthandler.model;

import java.util.Date;
import java.util.HashSet;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.OneToMany;
import javax.persistence.Table;

@Entity
@Table(name = "project")
public class  Project extends BaseEntity implements java.io.Serializable {

	private static final long serialVersionUID = 4903605340425810423L;
	
	@Column(name = "name")
	private String name;
	
	@Column(name = "description")
	private String description;
	
	@Column(name = "date_begin")
	private Date dateBegin;
	
	@Column(name = "date_end")
	private Date dateEnd;
	
	@OneToMany(fetch = FetchType.LAZY, mappedBy = "project")
	private Set<Task> tasks = new HashSet<Task>(0);
	
	public Project() {
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
	
	public Date getDateBegin() {
		return dateBegin;
	}
	
	public void setDateBegin(Date dateBegin) {
		this.dateBegin = dateBegin;
	}
	
	public Date getDateEnd() {
		return dateEnd;
	}
	
	public void setDateEnd(Date dateEnd) {
		this.dateEnd = dateEnd;
	}

	public Set<Task> getTasks() {
		return tasks;
	}

	public void setTasks(Set<Task> tasks) {
		this.tasks = tasks;
	}

}
