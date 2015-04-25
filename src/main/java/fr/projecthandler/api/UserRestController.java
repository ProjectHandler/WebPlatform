package fr.projecthandler.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import fr.projecthandler.model.Civility;
import fr.projecthandler.model.Token;
import fr.projecthandler.model.User;
import fr.projecthandler.service.TokenService;
import fr.projecthandler.service.UserService;
import fr.projecthandler.session.CustomUserDetails;

@RestController
@Transactional
@RequestMapping("/api/user")
public class UserRestController {

	@Autowired
	UserService userService;

	@Autowired
	TokenService tokenService;
	
	@Autowired
	@Qualifier("userDatabase")
	private AuthenticationManager authManager;
	
	@Autowired
	private UserDetailsService	customUserDetailsService;
	
	@RequestMapping(value = "/authenticate", method = RequestMethod.GET)
	public ResponseEntity<String> authenticate(@RequestParam("email") String email, @RequestParam("password") String password)
	{
		UsernamePasswordAuthenticationToken authenticationToken = new UsernamePasswordAuthenticationToken(email, password);
		Authentication authentication = null;
		
		try {
			authentication = this.authManager.authenticate(authenticationToken);
		} catch (AuthenticationException e) {
			return new ResponseEntity<String>("{\"status\":401, \"message\":\"Bad credentials\"}", HttpStatus.UNAUTHORIZED);
		}
		SecurityContextHolder.getContext().setAuthentication(authentication);

		CustomUserDetails userDetails = (CustomUserDetails) this.customUserDetailsService.loadUserByUsername(email);
		Token token = tokenService.findTokenByUserId(userDetails.getId());
		
		if (token == null) {
			return new ResponseEntity<String>("pas de token", HttpStatus.OK);
		}
		
		return new ResponseEntity<String>(token.getToken(), HttpStatus.OK);
	}

	
	@RequestMapping(value = "/get/{id}", method = RequestMethod.GET)
	public User get(@PathVariable Long id) {

		User u = userService.findUserById(id);

		return u;
	}
	
	@RequestMapping(value = "/civility/get/{id}", method = RequestMethod.GET)
	public Civility getCivility(@PathVariable Long id) {

		return null;
	}
//	@RequestMapping(value = "/post/{id}", method = RequestMethod.POST)
//	@ResponseStatus(HttpStatus.CREATED)
//	public User save() {
//
//		
//	}
}
