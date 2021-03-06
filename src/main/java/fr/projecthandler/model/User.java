package fr.projecthandler.model;

import java.util.HashSet;
import java.util.List;
import java.util.Locale;
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
import javax.persistence.Transient;
import javax.validation.constraints.Size;

import com.google.gson.annotations.Expose;

import fr.projecthandler.enums.AccountStatus;
import fr.projecthandler.enums.UserRole;
import fr.projecthandler.util.HtmlSanitizer;
import fr.projecthandler.util.Utilities;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@Entity
@Table(name = "users")
@ApiModel
public class User extends BaseEntity implements java.io.Serializable {

	private static final long serialVersionUID = -5538144362291281238L;

	private static final int PASSWORD_MIN_SIZE = 8;

	@ManyToOne(fetch = FetchType.EAGER)
	@JoinColumn(name = "civility_id")
	private Civility civility;

	@ApiModelProperty()
	@Column(name = "first_name", length = 30)
	@Expose
	private String firstName;

	@Column(name = "last_name", length = 30)
	@Expose
	private String lastName;

	// @JsonIgnore
	@Column(name = "password", length = 70)
	private String password;

	@Column(name = "user_role")
	private UserRole userRole;

	@OneToMany(fetch = FetchType.LAZY, mappedBy = "user")
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

	@Column(name = "work_day")
	private String workDay;

	@Column(name = "daily_hour")
	private String dailyHour;

	@Column(name = "avatar_file_name")
	private String avatarFileName;

	@Column(name = "draft_message", length = 500)
	private String draftMessage;

	@ManyToMany(fetch = FetchType.LAZY)
	@JoinTable(name = "users_groups", joinColumns = { @JoinColumn(name = "users_id", referencedColumnName = "id") }, inverseJoinColumns = {
			@JoinColumn(name = "groups_id", referencedColumnName = "id") })
	private List<Group> groups;

	@ManyToMany(fetch = FetchType.LAZY)
	@JoinTable(name = "users_projects", joinColumns = { @JoinColumn(name = "user_id", referencedColumnName = "id") }, inverseJoinColumns = {
			@JoinColumn(name = "project_id", referencedColumnName = "id") })
	private List<Project> projects;

	@ManyToMany(fetch = FetchType.LAZY)
	@JoinTable(name = "users_tasks", joinColumns = { @JoinColumn(name = "users_id", referencedColumnName = "id") }, inverseJoinColumns = {
			@JoinColumn(name = "tasks_id", referencedColumnName = "id") })
	private List<Task> tasks;

	@Column(name = "locale", length = 20)
	private Locale locale;

	@Transient
	@Size(min = PASSWORD_MIN_SIZE)
	private String rawPassword;

	public User() {
		// Default settings for a new user
		this.setAccountStatus(AccountStatus.INACTIVE);
		this.setUserRole(UserRole.ROLE_SIMPLE_USER);
		this.setDailyHour("09:00 AM - 05:00 PM");
		this.setWorkDay("tttttff");
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
		this.firstName = Utilities.truncate(firstName, 30);
	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = Utilities.truncate(lastName, 30);
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

	public String getWorkDay() {
		return workDay;
	}

	public void setWorkDay(String workDay) {
		this.workDay = workDay;
	}

	public String getDailyHour() {
		return dailyHour;
	}

	public void setDailyHour(String dailyHour) {
		this.dailyHour = dailyHour;
	}

	public String getAvatarFileName() {
		return avatarFileName;
	}

	public void setAvatarFileName(String avatarFileName) {
		this.avatarFileName = avatarFileName;
	}

	public String getPhone() {
		return phone;
	}

	public void setPhone(String phone) {
		this.phone = Utilities.truncate(phone, 10);
	}

	public String getMobilePhone() {
		return mobilePhone;
	}

	public void setMobilePhone(String mobilePhone) {
		this.mobilePhone = Utilities.truncate(mobilePhone, 10);
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

	public void setDrafMessage(String msg) {
		this.draftMessage = Utilities.truncate(HtmlSanitizer.sanitizeDrafMessage(msg), 500);
	}

	public String getDraftMessage() {
		return this.draftMessage;
	}

	public String getRawPassword() {
		return rawPassword;
	}

	public void setRawPassword(String rawPassword) {
		this.rawPassword = rawPassword;
	}

	public Locale getLocale() {
		return locale;
	}

	public void setLocale(Locale locale) {
		this.locale = locale;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = super.hashCode();
		result = prime * result + ((email == null) ? 0 : email.hashCode());
		result = prime * result + ((firstName == null) ? 0 : firstName.hashCode());
		result = prime * result + ((lastName == null) ? 0 : lastName.hashCode());
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
		User other = (User) obj;
		if (email == null) {
			if (other.email != null)
				return false;
		} else if (!email.equals(other.email))
			return false;
		if (firstName == null) {
			if (other.firstName != null)
				return false;
		} else if (!firstName.equals(other.firstName))
			return false;
		if (lastName == null) {
			if (other.lastName != null)
				return false;
		} else if (!lastName.equals(other.lastName))
			return false;
		return true;
	}

	@Override
	public String toString() {
		return "User is : [civility=" + civility + ", firstName=" + firstName + ", lastName=" + lastName + ", email=" + email + "]";
	}

}