package fr.projecthandler.util;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;

public final class DateHelper {
	public static String getDateString(String format, int numberOfDays) {
		DateFormat dateFormat = new SimpleDateFormat(format);
		Calendar cal = Calendar.getInstance();
		cal.add(Calendar.DATE, numberOfDays);
		return dateFormat.format(cal.getTime());
	}

	public static String getYesterdayDate(String format) {
		return getDateString(format, -1);
	}

	public static String getTodayDate(String format) {
		return getDateString(format, 0);
	}

	public static String getTomorrowDate(String format) {
		return getDateString(format, 1);
	}
}
