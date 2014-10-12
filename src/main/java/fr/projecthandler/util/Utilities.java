package fr.projecthandler.util;

import java.util.List;

import javax.persistence.Query;

public class Utilities {

	public static <T> T getSingleResultOrNull(Query query) {
		query.setMaxResults(1);
		List<T> list = query.getResultList();
		if (list.isEmpty()) {
			return null;
		}
		return list.get(0);
	}
	
}