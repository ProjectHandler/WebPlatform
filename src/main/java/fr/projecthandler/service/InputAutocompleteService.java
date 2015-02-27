package fr.projecthandler.service;

import java.util.List;

import fr.projecthandler.model.Token;
import fr.projecthandler.model.User;

public interface InputAutocompleteService {
	public List<User> getMatchingUsers(final List<User> userList, String search);

	public String userListToJson(final List<User> userList);
}
