package fr.projecthandler.api.documentation;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import springfox.documentation.builders.PathSelectors;
import springfox.documentation.service.ApiInfo;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;
import springfox.documentation.swagger2.annotations.EnableSwagger2;
import com.google.common.base.Predicate;

@Configuration
@EnableSwagger2
public class SwaggerConfiguration {
	@Bean
	public Docket customImplementation() {
		return new Docket(DocumentationType.SWAGGER_2)
				.select()
					.paths(paths()) // and by paths
					.build()
				.apiInfo(getApiInfo());
	}

	private ApiInfo getApiInfo() {
		ApiInfo info = new ApiInfo("ProjectHandler Rest API", "API Documentation", "0.1.0", "", "", "", "");
		return info;
	}

	private Predicate<String> paths() {
		return PathSelectors.regex(".*/api.*");
	}
}