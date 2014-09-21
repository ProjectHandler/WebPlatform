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

	public Query getQuery(String nomQuery, Map<String, Object> parametres) {
		Query q = em.createNamedQuery(nomQuery);
		if (parametres != null) {
			Set<String> keys = parametres.keySet();
			Object currentEntry;
			for (String key : keys) {
				currentEntry = parametres.get(key);
				q.setParameter(key, currentEntry);
			}
		}
		return q;
	}

}

