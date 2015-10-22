package fr.projecthandler.api.authentication;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.http.HttpStatus;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.LoginUrlAuthenticationEntryPoint;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import fr.projecthandler.exception.ExceptionJSONInfo;

public class CustomAuthenticationEntryPoint extends LoginUrlAuthenticationEntryPoint {

	public CustomAuthenticationEntryPoint(String loginUrl) {
		super(loginUrl);
	}
	
	@Override
	public void commence(HttpServletRequest request, HttpServletResponse response,
			AuthenticationException authException) throws IOException, ServletException {
		
		if (isMobileRequest(request)) {
			String message = "Unauthorized: Authentication token was either missing or invalid.";
			int status = HttpServletResponse.SC_UNAUTHORIZED;
			String json = "";
		
			response.setContentType("application/json");
			response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
			PrintWriter writer = response.getWriter();
		
			ExceptionJSONInfo exceptionInfo = new ExceptionJSONInfo();
			exceptionInfo.setUrl(request.getRequestURL().toString());
			exceptionInfo.setMessage(message);
			exceptionInfo.setStatus(status);
			Gson gson = new GsonBuilder().disableHtmlEscaping().create();
			try {
				json = gson.toJson(exceptionInfo);
			} catch (Exception e) {
				e.printStackTrace();
			}
		
			writer.println(json);
		} else {
			if (isAjax(request)) {
				response.sendError(HttpStatus.UNAUTHORIZED.value(), "Please re-authenticate yourself");
			} else {
				super.commence(request, response, authException);
			}
		}
	}

	public static boolean isMobileRequest(HttpServletRequest request) {
		return (request.getRequestURI().indexOf("/mobile/") != -1);
	}
	
	public static boolean isAjax(HttpServletRequest request) {
		return "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));
	}
}