package fr.projecthandler.dto;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import fr.projecthandler.enums.AccountStatus;
import fr.projecthandler.enums.UserRole;
import fr.projecthandler.model.Address;
import fr.projecthandler.model.Civility;
import fr.projecthandler.model.Event;
import fr.projecthandler.model.Group;
import fr.projecthandler.model.Project;
import fr.projecthandler.model.Task;
import fr.projecthandler.model.User;

public class UserDTO {

	private Civility civility;
	private String firstName;
	private String lastName;
	private String password;
	private UserRole userRole;
	private Set<Address> address = new HashSet<Address>(0);
	private String email;
	private String phone;
	private String mobilePhone;
	private AccountStatus accountStatus;
	private List<Group> groups;
	private List<Project> projects;
	private List<Task> tasks;
	
	public UserDTO(User user) {
		this.civility = user.getCivility();
		this.firstName = user.getFirstName();
		this.lastName = user.getLastName();
		this.password = user.getPassword();
		this.userRole = user.getUserRole();
		
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