package fr.projecthandler.enums;

public enum ApplicationSettingEnum {
	AVATAR_MAX_SIZE(10, "avatar_max_size"), DOCUMENT_MAX_SIZE(11, "document_max_size");

	private Integer id;
	private String key;

	private ApplicationSettingEnum(Integer id, String key) {
		this.id = id;
		this.key = key;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getKey() {
		return key;
	}

	public void setKey(String key) {
		this.key = key;
	}

	public static String findById(Integer id) {
		if (id != null) {
			for (ApplicationSettingEnum appSetting : ApplicationSettingEnum.values()) {
				if (appSetting.getId().equals(id)) {
					return appSetting.getKey();
				}
			}
		}

		return null;
	}

	public static Integer findIdByKey(String key) {
		if (key != null) {
			for (ApplicationSettingEnum appSetting : ApplicationSettingEnum.values()) {
				if (key.equals(appSetting.getKey())) {
					return appSetting.getId();
				}
			}
		}

		return null;
	}
}
