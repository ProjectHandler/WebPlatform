package fr.projecthandler.model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.PrePersist;
import javax.persistence.PreUpdate;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.validation.Valid;
import javax.validation.constraints.Size;

import fr.projecthandler.enums.TicketStatus;
import fr.projecthandler.util.TimestampEntity;

@Entity
@Table(name = "tickets")
public class Ticket extends BaseEntity implements java.io.Serializable, TimestampEntity  {

	private static final long serialVersionUID = 254665316357554236L;

	@Size(min=1, max=100)
	@Column(name = "title", length = 100)
	private String title;
	
	@Column(name = "text", length = 500)
	private String text;
	
	@Column(name = "ticket_status", nullable = false)
	TicketStatus ticketStatus;
	
	//Author
	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "user_id")
	private User user;
	
	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "project_id", nullable = false)
	@Valid
	private Project project;
	
	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "ticket_tracker_id")
	private TicketTracker ticketTracker;

	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "ticket_priority_id")
	private TicketPriority ticketPriority;

	//List of recipients
	@ManyToMany(fetch = FetchType.LAZY)
	@JoinTable(name = "users_tickets", joinColumns = { @JoinColumn(name = "ticket_id", referencedColumnName = "id") }, inverseJoinColumns = { @JoinColumn(name = "user_id", referencedColumnName = "id") })
	private List<User> users = new ArrayList<User>();;
	
    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "created_at", nullable = false, updatable=false)
    private Date createdAt;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "updated_at", nullable = false)
    private Date updatedAt;
    
	public Ticket() {
		this.setTicketStatus(TicketStatus.OPEN);
	}
	
    @PrePersist
    protected void createAtTimestamp() {
    	updatedAt = createdAt = new Date();
    }

    @PreUpdate
    protected void updateAtTimestamp() {
    	updatedAt = new Date();
    }
    
	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

	public TicketStatus getTicketStatus() {
		return ticketStatus;
	}

	public void setTicketStatus(TicketStatus ticketStatus) {
		this.ticketStatus = ticketStatus;
	}

	public Date getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Date createdAt) {
		this.createdAt = createdAt;
	}

	public Date getUpdatedAt() {
		return updatedAt;
	}

	public void setUpdatedAt(Date updatedAt) {
		this.updatedAt = updatedAt;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	public Project getProject() {
		return project;
	}

	public void setProject(Project project) {
		this.project = project;
	}

	public TicketTracker getTicketTracker() {
		return ticketTracker;
	}

	public void setTicketTracker(TicketTracker ticketTracker) {
		this.ticketTracker = ticketTracker;
	}

	public TicketPriority getTicketPriority() {
		return ticketPriority;
	}

	public void setTicketPriority(TicketPriority ticketPriority) {
		this.ticketPriority = ticketPriority;
	}

	public List<User> getUsers() {
		return users;
	}

	public void setUsers(List<User> users) {
		this.users = users;
	}

	@Override
	public String toString() {
		return "Ticket [title=" + title + ", text=" + text + ", ticketStatus="
				+ ticketStatus + ", user=" + user + ", project=" + project
				+ ", ticketTracker=" + ticketTracker + ", ticketPriority="
				+ ticketPriority + ", users=" + users + ", createdAt="
				+ createdAt + ", updatedAt=" + updatedAt + "]";
	}
}
