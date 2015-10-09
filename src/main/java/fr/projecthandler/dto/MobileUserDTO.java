package fr.projecthandler.dto;

import fr.projecthandler.model.User;

public class MobileUserDTO {

    private Long id;
    private String civility;
    private String firstName;
    private String lastName;
    private String userRole;
    private String email;
    private String phone;
    private String mobilePhone;
    private String accountStatus;

    public MobileUserDTO() {

    }

    public MobileUserDTO(User user) {
	this.id = user.getId();
	this.civility = user.getCivility().getName();
	this.firstName = user.getFirstName();
	this.lastName = user.getLastName();
	this.userRole = user.getUserRole().toString();
	this.email = user.getEmail();
	this.phone = user.getPhone();
	this.mobilePhone = user.getMobilePhone();
	this.accountStatus = user.getAccountStatus().getValue();
    }

    public Long getId() {
	return id;
    }

    public void setId(Long id) {
	this.id = id;
    }

    public String getCivility() {
	return civility;
    }

    public void setCivility(String civility) {
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

    public String getUserRole() {
	return userRole;
    }

    public void setUserRole(String userRole) {
	this.userRole = userRole;
    }

    public String getEmail() {
	return email;
    }

    public void setEmail(String email) {
	this.email = email;
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

    public String getAccountStatus() {
	return accountStatus;
    }

    public void setAccountStatus(String accountStatus) {
	this.accountStatus = accountStatus;
    }

}
