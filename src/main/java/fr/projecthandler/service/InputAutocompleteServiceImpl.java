package fr.projecthandler.service;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.owasp.encoder.Encode;
import org.springframework.stereotype.Service;

import fr.projecthandler.model.User;

@Service
public class InputAutocompleteServiceImpl implements InputAutocompleteService {

	final int USER_JSON_SIZE = 80;
	
	//TODO delete and replace by an appropriate query
	public List<User> getMatchingUsers(final List<User> userList, String search) {
		
		List<User> result = new ArrayList<User>();

		for (Iterator<User> iterator = userList.iterator(); iterator.hasNext();) {
		    User u = iterator.next();
			String firstName = u.getFirstName() == null ? "" : u.getFirstName();
			String lastName = u.getLastName() == null ? "" : u.getLastName();
			String fullName = firstName + " " + lastName;
			String reverseFullName = lastName + " " + firstName;
			
			if (fullName.toLowerCase().contains(search.toLowerCase())
					|| reverseFullName.toLowerCase().contains(search.toLowerCase())
					|| u.getEmail().toLowerCase().contains(search.toLowerCase())) {
				result.add(u);
			}
		}
		
		return result;
	}

	public String userListToJson(final List<User> userList) {
		StringBuilder result = new StringBuilder(userList.size() * USER_JSON_SIZE);
		boolean comma = false;

		result.append('[');
		for (User u : userList) {
			String firstName = u.getFirstName() == null ? "" : u.getFirstName();
//			String lastName = u.getLastName() == null ? "" : u.getLastName();
			if (comma) {
				result.append(',');
			}
			result.append("{\"id\":\"").append(u.getId()).append("\",");
			result.append("\"name\":\"").append(
					Encode.forJavaScript(Encode.forHtml(firstName)));
			result.append(" &lt;mail:")
					.append(Encode.forJavaScript(Encode.forHtml(u.getEmail())))
					.append("&gt;");
			result.append("\"}");
			comma = true;
		}
		result.append(']');
		
		return result.toString();
	}

}
