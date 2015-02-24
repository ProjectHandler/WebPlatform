package fr.projecthandler.formatter;

import org.springframework.format.FormatterRegistry;

import org.springframework.format.support.FormattingConversionServiceFactoryBean;

import fr.projecthandler.model.Project;

public class CustomFormattingConversionServiceFactoryBean extends FormattingConversionServiceFactoryBean {

    @Override
    protected void installFormatters(FormatterRegistry registry) {
        super.installFormatters(registry);
        
        // When registered by binding field type and Formatter
        registry.addFormatterForFieldType(Project.class, new ProjectFormatter());
        
    }
}