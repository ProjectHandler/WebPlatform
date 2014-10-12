package fr.projecthandler.dao;

import java.util.Map;
import java.util.Set;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;

public class AbstractDao {

	@PersistenceContext
	protected EntityManager em;

	public AbstractDao() {
		super();
	}

	public Query getQuery(String namedQuery, Map<String, Object> parameters) {
		Query q = em.createNamedQuery(namedQuery);
		if (parameters != null) {
			Set<String> keys = parameters.keySet();
			Object currentEntry;
			for (String key : keys) {
				currentEntry = parameters.get(key);
				q.setParameter(key, currentEntry);
			}
		}
		return q;
	}

}