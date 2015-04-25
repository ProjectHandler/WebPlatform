package fr.projecthandler.api.authentication;

import java.io.IOException;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.web.filter.GenericFilterBean;

import fr.projecthandler.model.User;
import fr.projecthandler.service.TokenService;
import fr.projecthandler.service.UserService;

public class AuthenticationTokenProcessingFilter extends GenericFilterBean {

    @Autowired
    UserService userService;
    
    @Autowired
    TokenService tokenService;

	@Autowired
	UserDetailsService customUserDetailsService;
	
    public AuthenticationTokenProcessingFilter() {
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		HttpServletRequest httpRequest = this.getAsHttpRequest(request);

		String token = extractAuthToken(httpRequest);
		User user = tokenService.findUserByToken(token);

            if (user != null) {
            	UserDetails userDetails = customUserDetailsService.loadUserByUsername(user.getEmail());
            	//Build an Authentication object with the user's info
                UsernamePasswordAuthenticationToken authentication = 
                        new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());
                authentication.setDetails(new WebAuthenticationDetailsSource().buildDetails(httpRequest));
                //Set the authentication into the SecurityContext
                SecurityContextHolder.getContext().setAuthentication(authentication);     
            }
            
        chain.doFilter(request, response);
    }
    
	private String extractAuthToken(HttpServletRequest request) {
		//Get the token from header
		String authToken = request.getHeader("X-Auth-Token");

		//If the token not found in the header, get it from the request parameters
		if (authToken == null) {
			authToken = request.getParameter("token");
		}

		return authToken;
	}

	private HttpServletRequest getAsHttpRequest(ServletRequest request) {
		if (!(request instanceof HttpServletRequest)) {
			throw new RuntimeException("Expecting an HTTP request");
		}

		return (HttpServletRequest) request;
	}
}