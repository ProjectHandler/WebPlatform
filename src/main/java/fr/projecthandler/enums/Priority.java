package fr.projecthandler.enums;

public enum Priority {
	LOW(0, "PRIORITY_LOW"), MEDIUM(1, "PRIORITY_MEDIUM"), HIGH(2, "PRIORITY_HIGH");

	private Integer value;
	private String name;

	private Priority(Integer id, String value) {
		this.value = id;
		this.name = value;
	}

	public Integer getValue() {
		return value;
	}

	public void setValue(Integer value) {
		this.value = value;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public static String findByValue(Integer value) {
		if (value != null) {
			for (Priority p : Priority.values()) {
				if (value.equals(p.getValue())) {
					return p.getName();
				}
			}
		}

		return null;
	}
}
