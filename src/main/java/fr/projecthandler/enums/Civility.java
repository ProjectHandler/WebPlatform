package fr.projecthandler.enums;

public enum Civility {

	M(0, "M."), MME(1, "Mme.");

	private Integer id;
	private String value;

	private Civility(Integer id, String value) {
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
			for (Civility civility : Civility.values()) {
				if (id.equals(civility.getId())) {
					return civility.getValue();
				}
			}
		}
		return null;
	}

	public static Civility findCivilityById(Integer id) {
		if (id != null) {
			for (Civility civility : Civility.values()) {
				if (id.equals(civility.getId())) {
					return civility;
				}
			}
		}
		return null;
	}

}