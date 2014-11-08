package fr.projecthandler.enums;

public enum AccountStatus {

	INACTIVE(0, "inactif"), ACTIVE(1, "actif"), MAIL_VALIDATED(2, "email validé");

	private Integer id;
	private String value;

	private AccountStatus(Integer id, String value) {
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
