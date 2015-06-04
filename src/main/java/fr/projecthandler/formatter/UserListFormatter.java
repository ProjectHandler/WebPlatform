package fr.projecthandler.formatter;

import java.text.ParseException;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.format.Formatter;
import org.springframework.stereotype.Component;

import fr.projecthandler.model.User;
import fr.projecthandler.service.UserService;

@Component
public class UserListFormatter implements Formatter<List<User>> {

	@Autowired
	private UserService userService;
	
	private final String delimiter = ",";
	
    @Override
	public String print(List<User> userList, Locale locale) {
		String str = new String();

		for (User user : userList) {
			str += user.getId() + delimiter;
		}
		
		return str;
	}

    @Override
	public List<User> parse(String userListString, Locale locale) throws ParseException {
		String[] array = userListString.split(delimiter);
		List<User> userList = new ArrayList<User>();

		for (String str : array) {
			// TODO replace by our own StringUtils ?
			if (StringUtils.isNumeric(str)) {
				User user = userService.findUserById(Long.parseLong(str));
				if (user != null) {
					userList.add(user);
				}
			}
		}

		return userList;
	}
}
