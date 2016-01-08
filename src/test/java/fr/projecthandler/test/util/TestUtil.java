package fr.projecthandler.test.util;

import java.nio.charset.Charset;

import org.springframework.http.MediaType;

public class TestUtil {
	
    public static final MediaType APPLICATION_JSON_UTF8 = new MediaType(MediaType.APPLICATION_JSON.getType(),
                                                                        MediaType.APPLICATION_JSON.getSubtype(),                        
                                                                        Charset.forName("utf8")                     
                                                                        );
    
    //TODO pas de token ici, ou token temporaire
    public static final String API_TOKEN = "3a485b9f-8ace-413a-8b2e-672b5309c198";
}
