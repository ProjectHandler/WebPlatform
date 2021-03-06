package fr.projecthandler.api.authentication;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.LoginUrlAuthenticationEntryPoint;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import fr.projecthandler.api.exception.ExceptionJsonInfo;

public class CustomAuthenticationEntryPoint extends LoginUrlAuthenticationEntryPoint {

	private static final Log log = LogFactory.getLog(CustomAuthenticationEntryPoint.class);

	public CustomAuthenticationEntryPoint(String loginUrl) {
		super(loginUrl);
	}

	@Override
	public void commence(HttpServletRequest request, HttpServletResponse response, AuthenticationException authException)
			throws IOException, ServletException {

		if (isApiRequest(request)) {
			int status = HttpServletResponse.SC_UNAUTHORIZED;
			String json = "";
			String message = "Authentication token was either missing or invalid";

			response.setContentType(MediaType.APPLICATION_JSON_VALUE);
			response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
			PrintWriter writer = response.getWriter();

			ExceptionJsonInfo exceptionInfo = new ExceptionJsonInfo();
			exceptionInfo.setUrl(request.getRequestURL().toString());
			exceptionInfo.setMessage(message);
			exceptionInfo.setStatus(status);
			Gson gson = new GsonBuilder().disableHtmlEscaping().create();
			try {
				json = gson.toJson(exceptionInfo);
			} catch (Exception e) {
				log.error("error in CustomAuthenticationEntryPoint for converting to json", e);
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

	public static boolean isApiRequest(HttpServletRequest request) {
		return (request.getRequestURI().contains("/api/"));
	}

	public static boolean isAjax(HttpServletRequest request) {
		return "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));
	}
}