package fr.projecthandler.model;

import java.util.List;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.Table;

@Entity
@Table(name = "groups")
public class Group extends BaseEntity implements java.io.Serializable {
	
	private static final long serialVersionUID = 7777936323140047759L;

	@Column(name = "name", length=50)
	private String name;

	@ManyToMany
	@JoinTable(name = "users_groups", joinColumns = { @JoinColumn(name = "groups_id", referencedColumnName = "id") }, inverseJoinColumns = { @JoinColumn(name = "users_id", referencedColumnName = "id") })
	private List<User> users;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public List<User> getUsers() {
		return users;
	}

	public void setUsers(List<User> users) {
		this.users = users;
	}
	
}
