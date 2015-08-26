package fr.projecthandler.enums;

public enum ProjectStatus {
	INACTIVE(0, "STATUS_INACTIVE"), ACTIVE(1, "STATUS_ACTIVE"), MAIL_VALIDATED(2, "STATUS_MAIL_VALIDATED");

	private Integer id;
	private String value;

	private ProjectStatus(Integer id, String value) {
		this.id = id;
		this.value = value;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	public static String findById(Integer id) {
		if (id != null) {
			for (AccountStatus accountStatus : AccountStatus.values()) {
				if (id.equals(accountStatus.getId())) {
					return accountStatus.getValue();
				}
			}
		}

		return null;
	}
}
