package fr.projecthandler.api;

import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestController;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import fr.projecthandler.annotation.CurrentUserDetails;
import fr.projecthandler.dto.MobileUserDTO;
import fr.projecthandler.dto.UserDTO;
import fr.projecthandler.enums.AccountStatus;
import fr.projecthandler.enums.UserRole;
import fr.projecthandler.model.Token;
import fr.projecthandler.model.User;
import fr.projecthandler.service.TokenService;
import fr.projecthandler.service.UserService;
import fr.projecthandler.session.CustomUserDetails;
import fr.projecthandler.util.TokenGenerator;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import io.swagger.annotations.ApiResponses;
import io.swagger.annotations.ApiResponse;

@RestController
@Transactional
@Api(value = "User", description = "Operations about users")
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
	private UserDetailsService customUserDetailsService;

	@RequestMapping(value = "/authenticate", method = RequestMethod.GET)
	@ApiOperation(value = "Checks the email and password. If succesful, returns the token used to authenticate the user", response=MobileUserDTO.class, produces=MediaType.APPLICATION_JSON_VALUE)
	@ApiResponses(value = {
		    @ApiResponse(code = HttpServletResponse.SC_OK, message = "Successful operation"),
		    @ApiResponse(code = HttpServletResponse.SC_UNAUTHORIZED, message = "Invalid email/password supplied")
		    }
		)
	public @ResponseBody Object authenticate(
			@ApiParam(value = "The email for login", required=true) @RequestParam("email") String email,
			@ApiParam(value = "The password for login in clear text", required=true) @RequestParam("password") String password) {
		UsernamePasswordAuthenticationToken authenticationToken = new UsernamePasswordAuthenticationToken(email, password);
		Authentication authentication = null;

		try {
			authentication = this.authManager.authenticate(authenticationToken);
		} catch (AuthenticationException e) {
			return new ResponseEntity<String>("{\"status\":401, \"message\":\"Bad credentials\"}",
					HttpStatus.UNAUTHORIZED);
		}
		SecurityContextHolder.getContext().setAuthentication(authentication);

		CustomUserDetails userDetails = (CustomUserDetails) this.customUserDetailsService.loadUserByUsername(email);
		Token token = tokenService.findTokenByUserId(userDetails.getId());

		// Generate a token if the user doesn't have one.
		if (token == null) {
			User u = userService.findUserById(userDetails.getId());
			token = new Token();

			if (u == null) {
				return new ResponseEntity<String>("{\"status\":505, \"message\":\"Internal Server Error\"}",
						HttpStatus.INTERNAL_SERVER_ERROR);
			}
			// TODO make sure token is unique ?
			token.setToken(TokenGenerator.generateToken());
			token.setTimeStamp(TokenGenerator.generateTimeStamp());
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
	@RequestMapping(value = "/get/{id}", method = RequestMethod.GET)
	public @ResponseBody ResponseEntity<String> get(@PathVariable Long id) {
		User user = userService.findUserById(id);

		if (user == null) {
			return new ResponseEntity<String>("{\"status\":400, \"message\":\"Not found\"}", HttpStatus.NOT_FOUND);
		}

		Gson gson = new GsonBuilder().setExclusionStrategies(new ApiExclusionStrategy()).create();
		try {
			String json = gson.toJson(new UserDTO(user));
			return new ResponseEntity<String>(json, HttpStatus.OK);
		} catch (Exception e) {
			e.printStackTrace();
			return new ResponseEntity<String>("KO", HttpStatus.BAD_REQUEST);
		}
	}

	//TODO vérifier si la fonction marche, faire la gestion d'erreur
	@RequestMapping(value = "/post", method = RequestMethod.POST)
	@ResponseStatus(HttpStatus.CREATED)
	@ApiOperation(value = "Creates a new user and returns the user details")
	@ApiResponses(value = {
		    @ApiResponse(code = HttpServletResponse.SC_CREATED, message = "User created", response = User.class),
		    @ApiResponse(code = HttpServletResponse.SC_BAD_REQUEST, message = "Incorrect user entity syntax")
		    }
		)
	public @ResponseBody UserDTO save(
			@ApiParam(required = true) @ModelAttribute @Valid User user,
			BindingResult result) {
		user.setAccountStatus(AccountStatus.ACTIVE);
		user.setUserRole(UserRole.ROLE_SIMPLE_USER);
		userService.saveUser(user);
		return new UserDTO(user);
	}
}
