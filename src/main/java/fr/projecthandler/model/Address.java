package fr.projecthandler.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;

import fr.projecthandler.util.Utilities;

@Entity
@Table(name = "address")
public class Address extends BaseEntity implements java.io.Serializable {

	private static final long serialVersionUID = 6633617983584163794L;

	@Column(name = "street_number", length = 10)
	private String streetNumber;

	@Column(name = "street_name", length = 30)
	private String streetName;

	@Column(name = "city", length = 30)
	private String city;

	@Column(name = "zipcode", length = 5)
	private String zipCode;

	@Column(name = "country", length = 30)
	private String country;

	@ManyToOne(fetch = FetchType.LAZY)
	@JoinColumn(name = "user_id")
	private User user;

	public Address() {
	}

	public String getStreetNumber() {
		return streetNumber;
	}

	public void setStreetNumber(String streetNumber) {
		this.streetNumber = Utilities.truncate(streetNumber, 10);
	}

	public String getStreetName() {
		return streetName;
	}

	public void setStreetName(String streetName) {
		this.streetName = Utilities.truncate(streetName, 30);
	}

	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = Utilities.truncate(city, 30);
	}

	public String getZipCode() {
		return zipCode;
	}

	public void setZipCode(String zipCode) {
		this.zipCode = Utilities.truncate(zipCode, 5);
	}

	public String getCountry() {
		return country;
	}

	public void setCountry(String country) {
		this.country = Utilities.truncate(country, 30);
	}

	public User getUser() {
		return user;
	}

	public void setUser(User user) {
		this.user = user;
	}

	@Override
	public String toString() {
		return "Address : " + streetNumber + " " + streetName + " " + zipCode + ", " + city + ", " + country;
	}
}
