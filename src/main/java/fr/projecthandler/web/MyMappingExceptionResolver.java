package fr.projecthandler.web;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.handler.SimpleMappingExceptionResolver;

public class MyMappingExceptionResolver extends SimpleMappingExceptionResolver {

	public MyMappingExceptionResolver() {
		// Enable logging by providing the name of the logger to use
		setWarnLogCategory(MyMappingExceptionResolver.class.getName());
	}

	@Override
	public String buildLogMessage(Exception e, HttpServletRequest req) {
		return "MVC exception: " + e.getLocalizedMessage();
	}

	@Override
	protected ModelAndView doResolveException(HttpServletRequest request, HttpServletResponse response, Object handler, Exception exception) {
		//response.sendRedirect(request.getContextPath() + "/accessDenied");
		Map<String, Object> myModel = new HashMap<String, Object>();
		myModel.put("requestURI", request.getRequestURI());
		myModel.put("exception", exception);

		return new ModelAndView("exception", myModel);
	}
}
