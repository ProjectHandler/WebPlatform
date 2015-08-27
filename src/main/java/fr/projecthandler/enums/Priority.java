package fr.projecthandler.enums;

public enum Priority {
	LOW(0, "PRIORITY_LOW"), MEDIUM(1, "PRIORITY_MEDIUM"), HIGH(2, "PRIORITY_HIGH");

	private Integer id;
	private String value;

	private Priority(Integer id, String value) {
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
			for (Priority p : Priority.values()) {
				if (id.equals(p.getId())) {
					return p.getValue();
				}
			}
		}

		return null;
	}
}
