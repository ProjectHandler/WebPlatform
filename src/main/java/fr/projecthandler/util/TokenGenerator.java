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

	// returns true if the token is out of date (compared to maximumTime)
	public static boolean checkTimestamp(Long timestamp, Long maximumTime) {
		java.util.Date currentDate = new java.util.Date();
		return (currentDate.getTime() - timestamp) > maximumTime;
	}
}
