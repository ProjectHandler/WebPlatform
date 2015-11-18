package fr.projecthandler.model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Set;

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
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;

import fr.projecthandler.dto.MobileTicketDTO;
import fr.projecthandler.enums.TicketStatus;
import fr.projecthandler.util.HtmlSanitizer;
import fr.projecthandler.util.TimestampEntity;
import fr.projecthandler.util.Utilities;

@Entity
@Table(name = "tickets")
public class Ticket extends BaseEntity implements java.io.Serializable, TimestampEntity {

	private static final long serialVersionUID = 254665316357554236L;

	public static final int TEXT_MIN_SIZE = 1;

	public static final int TEXT_MAX_SIZE = 500;

	public static final int TITLE_MIN_SIZE = 4;

	public static final int TITLE_MAX_SIZE = 100;

	@Size(min = TITLE_MIN_SIZE, max = TITLE_MAX_SIZE)
	@Column(name = "title", length = TITLE_MAX_SIZE)
	private String title;

	@Size(min = TEXT_MIN_SIZE, max = TEXT_MAX_SIZE)
	@Column(name = "text", length = TEXT_MAX_SIZE)
	private String text;

	@NotNull
	@Column(name = "ticket_status", nullable = false)
	private TicketStatus ticketStatus;

	// Author
	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "user_id")
	private User user;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "project_id", nullable = false)
	@Valid
	private Project project;

	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "ticket_tracker_id")
	private TicketTracker ticketTracker;

	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "ticket_priority_id")
	private TicketPriority ticketPriority;

	@ManyToMany(fetch = FetchType.LAZY,  mappedBy = "ticket")
	private Set<TicketMessage> ticketMessages;
	
	// @JsonIgnore
	// List of recipients
	@ManyToMany(fetch = FetchType.LAZY)
	@JoinTable(name = "users_tickets", joinColumns = { @JoinColumn(name = "ticket_id", referencedColumnName = "id") }, inverseJoinColumns = { @JoinColumn(name = "user_id", referencedColumnName = "id") })
	private List<User> users = new ArrayList<User>();;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "created_at", nullable = false, updatable = false)
	private Date createdAt;

	@Temporal(TemporalType.TIMESTAMP)
	@Column(name = "updated_at", nullable = false)
	private Date updatedAt;

	public Ticket() {
		this.setTicketStatus(TicketStatus.OPEN);
	}

	public Ticket(MobileTicketDTO ticketDTO) {
		this.title = ticketDTO.getTitle();
		this.text = ticketDTO.getText();
		this.project = new Project();
		this.project.setId(ticketDTO.getProjectId());
		this.ticketPriority.setId(ticketDTO.getTicketPriority().getId());
		this.createdAt = ticketDTO.getCreatedAt();
		this.updatedAt = ticketDTO.getUpdatedAt();
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
		this.title = Utilities.truncate(title, TITLE_MAX_SIZE);
	}

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = Utilities.truncate(HtmlSanitizer.sanitizeTicketText(text), TEXT_MAX_SIZE);
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

	public int getTextMinSize() {
		return TEXT_MIN_SIZE;
	}

	public int getTextMaxSize() {
		return TEXT_MAX_SIZE;
	}

	public int getTitleMinSize() {
		return TITLE_MIN_SIZE;
	}

	public int getTitleMaxSize() {
		return TITLE_MAX_SIZE;
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

	public Set<TicketMessage> getTicketMessages() {
		return ticketMessages;
	}

	public void setTicketMessages(Set<TicketMessage> ticketMessages) {
		this.ticketMessages = ticketMessages;
	}
}
