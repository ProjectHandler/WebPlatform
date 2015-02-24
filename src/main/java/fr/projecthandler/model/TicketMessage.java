package fr.projecthandler.model;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.PrePersist;
import javax.persistence.PreUpdate;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import fr.projecthandler.util.TimestampEntity;

@Entity
@Table(name = "ticket_messages")
public class TicketMessage extends BaseEntity implements java.io.Serializable, TimestampEntity  {

	private static final long serialVersionUID = 254665316357554236L;

    @ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "ticket_id", nullable = false)
	private Ticket ticket;

    @ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "user_id")
	private User user;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "created_at", nullable = false, updatable=false)
    private Date createdAt;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "updated_at", nullable = false)
    private Date updatedAt;
    
	@Column(name = "text", length = 500)
	private String text;
    
	public TicketMessage() {
	}
	
    public Ticket getTicket() {
		return ticket;
	}

	public void setTicket(Ticket ticket) {
		this.ticket = ticket;
	}

	@PrePersist
    protected void createAtTimestamp() {
    	updatedAt = createdAt = new Date();
    }

    @PreUpdate
    protected void updateAtTimestamp() {
    	updatedAt = new Date();
    }

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
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
}