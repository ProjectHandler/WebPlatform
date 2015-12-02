package fr.projecthandler.api;

import fr.projecthandler.annotation.CurrentUserDetails;
import fr.projecthandler.api.exception.ApiAuthenticationException;
import fr.projecthandler.api.exception.ApiBadRequestException;
import fr.projecthandler.api.exception.ApiInternalErrorException;
import fr.projecthandler.api.exception.ApiNotFoundException;
import fr.projecthandler.dto.MobileUserDTO;
import fr.projecthandler.dto.UserDTO;
import fr.projecthandler.enums.AccountStatus;
import fr.projecthandler.enums.UserRole;
import fr.projecthandler.model.Token;
import fr.projecthandler.model.User;
import fr.projecthandler.service.MailService;
import fr.projecthandler.service.TokenService;
import fr.projecthandler.service.UserService;
import fr.projecthandler.session.CustomUserDetails;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import springfox.documentation.annotations.ApiIgnore;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

@RestController
@Transactional
@Api(value = "User", description = "Operations about users")
@RequestMapping(value = "/api/user", produces = MediaType.APPLICATION_JSON_VALUE + ";charset=UTF-8")
public class UserRestController {

	private static final Logger log = LoggerFactory.getLogger(UserRestController.class);

	@Autowired
	BCryptPasswordEncoder passwordEncoder;

	@Autowired
	UserService userService;

	@Autowired
	TokenService tokenService;

	@Autowired
	MailService mailService;

	@Autowired
	@Qualifier("userDatabase")
	private AuthenticationManager authManager;

	@Autowired
	private UserDetailsService customUserDetailsService;

	// TODO Return token object
	@RequestMapping(value = "/authenticate", method = RequestMethod.GET)
	@ApiOperation(value = "Checks the email and password. If succesful, returns the token used to authenticate the user", produces=MediaType.APPLICATION_JSON_VALUE)
	@ApiResponses(value = {
		    @ApiResponse(code = HttpServletResponse.SC_OK, message = "Successful operation"),
		    @ApiResponse(code = HttpServletResponse.SC_UNAUTHORIZED, message = "Invalid email/password supplied")
		    }
		)
	public Object authenticate(@ApiParam(value = "The email for login", required = true) @RequestParam("email") String email,
			@ApiParam(value = "The password for login in clear text", required = true) @RequestParam("password") String password)
					throws ApiAuthenticationException, ApiInternalErrorException {
		UsernamePasswordAuthenticationToken authenticationToken = new UsernamePasswordAuthenticationToken(email, password);
		Authentication authentication = null;

		try {
			authentication = this.authManager.authenticate(authenticationToken);
		} catch (AuthenticationException e) {
			throw new ApiAuthenticationException("Bad credentials");
		}
		SecurityContextHolder.getContext().setAuthentication(authentication);

		CustomUserDetails userDetails = (CustomUserDetails) this.customUserDetailsService.loadUserByUsername(email);
		Token token = tokenService.findTokenByUserId(userDetails.getId());

		// Generate a token if the user doesn't have one.
		if (token == null) {
			User u = userService.findUserById(userDetails.getId());
			
			if (u == null) {
				throw new ApiInternalErrorException();
			}
			// TODO make sure token is unique
			token = new Token();
			token.setUser(u);
			tokenService.saveToken(token);
		}

		return new ResponseEntity<String>("{\"token\":" + token.getToken() + "}", HttpStatus.OK);
	}

	@ApiOperation(value = "Gets user details by id", response=MobileUserDTO.class)
	@ApiResponses(value = {
		    @ApiResponse(code = HttpServletResponse.SC_OK, message = "Successful retrieval of user detail", response = User.class),
		    @ApiResponse(code = HttpServletResponse.SC_NOT_FOUND, message = "User with given id does not exist")
		    }
		)
	@RequestMapping(value = "/get/{userId}", method = RequestMethod.GET)
	public ResponseEntity<String> get(@PathVariable Long userId) throws ApiNotFoundException, ApiInternalErrorException {
		User user = userService.findUserById(userId);

		if (user == null) {
			throw new ApiNotFoundException(userId);
		}
		Gson gson = new GsonBuilder().setExclusionStrategies(new ApiExclusionStrategy()).create();
		String json = gson.toJson(new UserDTO(user));
		return new ResponseEntity<String>(json, HttpStatus.OK);
	}

	// TODO check why validation isn't triggered
	// TODO check if email is already taken
	// TODO remove field raw password and check manually ?
	@RequestMapping(value = "/save", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.CREATED)
	@ApiOperation(value = "Creates a new user and returns the user details", notes = "If the password is empty, an email will be sent to the new user for him to complete his registration.")
	@ApiResponses(value = {
			@ApiResponse(code = HttpServletResponse.SC_CREATED, message = "User created", response = User.class),
			@ApiResponse(code = HttpServletResponse.SC_BAD_REQUEST, message = "Incorrect user entity syntax")
		    }
		)
	public UserDTO save(@ApiIgnore  HttpServletRequest request,
			@ApiIgnore @CurrentUserDetails CustomUserDetails userDetails,
			@ApiParam(required = true) @RequestBody @Valid User user,
			BindingResult result) throws ApiBadRequestException {
		// TODO check with annotation or spring-security.xml
		if (!userDetails.hasRole(UserRole.ROLE_ADMIN)) {
			throw new AccessDeniedException("Admin role required");
		}
		if (result.hasErrors()) {
			String message = "Invalid user format";
			for (FieldError error: result.getFieldErrors()) {
				message += " - " + error.getField() + " : " + error.getDefaultMessage();
			}
			throw new ApiBadRequestException(message);
		}
		if (StringUtils.isEmpty(user.getRawPassword())) {
			// Send an email to the user so that he can confirm his email address and complete his profile
			Token token = new Token();
			token.setUser(user);
			tokenService.saveToken(token);
			mailService.sendEmailUserCreation(user, tokenService.buildTokenUrl(request, user, token));
		}
		else {
			user.setPassword(passwordEncoder.encode(user.getRawPassword()));
			user.setRawPassword(null);
			user.setAccountStatus(AccountStatus.ACTIVE);
		}
		userService.saveUser(user);
		return new UserDTO(user);
	}
}
