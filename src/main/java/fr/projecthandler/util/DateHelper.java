package fr.projecthandler.util;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

public final class DateHelper {
	public static long MILISECONDS_IN_ONE_DAY = 86400000;
	
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
	
	public static Long getDaysDuration(Date start, Date end) {
		System.out.println("start time = " + start.getTime());
		System.out.println("end time = " + end.getTime());
		return new Long((end.getTime() - start.getTime()) / DateHelper.MILISECONDS_IN_ONE_DAY);
	}
}
