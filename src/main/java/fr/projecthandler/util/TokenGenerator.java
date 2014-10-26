package fr.projecthandler.util;

import java.util.UUID;

public class TokenGenerator {
	public static String generateToken() {
		return UUID.randomUUID().toString();
	}

	public static Long generateTimeStamp() {
		java.util.Date currentDate = new java.util.Date();
		return currentDate.getTime();
	}
}
