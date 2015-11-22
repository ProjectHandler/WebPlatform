package fr.projecthandler.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "application_settings")
public class ApplicationSetting extends BaseEntity implements java.io.Serializable {

	private static final long serialVersionUID = 7984611998601260279L;
	
	@Column(name = "setting_key", length = 100)
	private String key;
	
	@Column(name = "setting_value", length = 100)
	private String value;
	
	@Column(name = "description", length = 200)
	private String description;

	public String getKey() {
		return key;
	}

	public void setKey(String key) {
		this.key = key;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

}
