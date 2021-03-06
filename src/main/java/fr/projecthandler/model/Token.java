package fr.projecthandler.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.OneToOne;
import javax.persistence.Table;

import com.fasterxml.jackson.annotation.JsonIgnore;

import fr.projecthandler.util.TokenGenerator;

@Entity
@Table(name = "tokens")
public class Token extends BaseEntity implements java.io.Serializable {

	private static final long serialVersionUID = 0L;

	@Column(name = "token", length = 50)
	private String token;

	@JsonIgnore
	@Column(name = "time_stamp")
	private Long timeStamp;

	@JsonIgnore
	@OneToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "user_id")
	private User user;

	public Token() {
		this.token = TokenGenerator.generateToken();
		this.timeStamp = TokenGenerator.generateTimeStamp();
	}

	public String getToken() {
		return token;
	}

	public void setToken(String token) {
		this.token = token;
	}

	public long getTimeStamp() {
		return timeStamp;
	}

	public void setTimeStamp(Long timeStamp) {
		this.timeStamp = timeStamp;
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	@Override
	public String toString() {
		return "Token [token=" + token + ", timeStamp=" + timeStamp + ", user=" + user + "]";
	}

}
