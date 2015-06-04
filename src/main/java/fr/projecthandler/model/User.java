package fr.projecthandler.model;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.ManyToOne;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import fr.projecthandler.enums.AccountStatus;
import fr.projecthandler.enums.UserRole;

@Entity
@Table(name = "users")
public class User extends BaseEntity implements java.io.Serializable {

	private static final long serialVersionUID = -5538144362291281238L;

	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "civility_id")
	private Civility civility;
	
	@Column(name = "first_name", length = 30)
	private String firstName;

	@Column(name = "last_name", length = 30)
	private String lastName;

	@Column(name = "password", length = 70)
	private String password;

	@Column(name = "user_role")
	private UserRole userRole;

	@OneToMany(fetch = FetchType.EAGER, mappedBy = "user")
	@Column(name = "address")
	private Set<Address> address = new HashSet<Address>(0);

	@Column(name = "email", length = 50)
	private String email;
	
	@Column(name = "phone", length = 10)
	private String phone;
	
	@Column(name = "mobile_phone", length = 10)
	private String mobilePhone;
	
	@Column(name = "account_status")
	private AccountStatus accountStatus;

	@ManyToMany(fetch = FetchType.EAGER)
	@JoinTable(name = "users_groups", joinColumns = { @JoinColumn(name = "users_id", referencedColumnName = "id") }, inverseJoinColumns = { @JoinColumn(name = "groups_id", referencedColumnName = "id") })
	private List<Group> groups;

	@ManyToMany(fetch = FetchType.LAZY)
	@JoinTable(name = "users_projects", joinColumns = { @JoinColumn(name = "user_id", referencedColumnName = "id") }, inverseJoinColumns = { @JoinColumn(name = "project_id", referencedColumnName = "id") })
	private List<Project> projects;
	
	@ManyToMany(fetch = FetchType.LAZY)
	@JoinTable(name = "users_tasks", joinColumns = { @JoinColumn(name = "users_id", referencedColumnName = "id") }, inverseJoinColumns = { @JoinColumn(name = "tasks_id", referencedColumnName = "id") })
	private List<Task> tasks;
	
	public User() {
	}

	public Civility getCivility() {
		return civility;
	}
	
	public void setCivility(Civility civility) {
		this.civility = civility;
	}
	
	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public UserRole getUserRole() {
		return userRole;
	}

	public void setUserRole(UserRole userRole) {
		this.userRole = userRole;
	}

	public Set<Address> getAddress() {
		return address;
	}

	public void setAddress(Set<Address> address) {
		this.address = address;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public AccountStatus getAccountStatus() {
		return accountStatus;
	}

	public void setAccountStatus(AccountStatus accountStatus) {
		this.accountStatus = accountStatus;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = phone;
	}

	public String getMobilePhone() {
		return mobilePhone;
	}

	public void setMobilePhone(String mobilePhone) {
		this.mobilePhone = mobilePhone;
	}

	public List<Group> getGroups() {
		return this.groups;
	}
	
	public void setGroups(List<Group> groups) {
		this.groups = groups;
	}
	
	public void addGroup(Group group) {
		this.groups.add(group);
	}
	
	public void removeGroup(Group group) {
		this.groups.remove(group);
	}
	
	public List<Project> getProjects() {
		return this.projects;
	}
	
	public void setProjects(List<Project> projects) {
		this.projects = projects;
	}
	
	public List<Task> getTasks() {
		return this.tasks;
	}
	
	public void setTasks(List<Task> tasks) {
		this.tasks = tasks;
	}
	
	@Override
	public String toString() {
		return "User is : [civility="+ civility +", firstName=" + firstName + ", lastName=" + lastName
				+ ", password=" /*+ password*/ + ", address=" + address
				+ ", email=" + email + "]";
	}
	
}