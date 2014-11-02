package fr.projecthandler.util;

import java.util.List;

import javax.persistence.Query;
import javax.servlet.http.HttpServletRequest;

public class Utilities {

	public static <T> T getSingleResultOrNull(Query query) {
		query.setMaxResults(1);
		List<T> list = query.getResultList();
		if (list.isEmpty()) {
			return null;
		}
		return list.get(0);
	}
	
	public static String getRequestParameter(HttpServletRequest request, String parameter) {
		if (request.getParameter(parameter) != null && !"undefined".equals(request.getParameter(parameter))) {
			return request.getParameter(parameter);
		}
		return null;
	}
}