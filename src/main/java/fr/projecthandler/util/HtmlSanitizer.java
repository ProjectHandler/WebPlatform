package fr.projecthandler.util;

import org.owasp.html.HtmlPolicyBuilder;
import org.owasp.html.PolicyFactory;
import org.owasp.html.Sanitizers;

public class HtmlSanitizer {
	public static String sanitizeDrafMessage(String msg) {
		PolicyFactory customPolicy = new HtmlPolicyBuilder()
			    .allowElements("li")
			    .allowElements("ul")
			    .allowElements("ol")
		    	.allowElements("p")
				.allowStandardUrlProtocols()
				.allowElements("a")
				.allowAttributes("href").onElements("a")
				.allowAttributes("target").matching(true, "_blank").onElements("a")
			    .requireRelNofollowOnLinks()
			    .toFactory();
		PolicyFactory policy = Sanitizers.FORMATTING.and(customPolicy);

		return policy.sanitize(msg);
	}

	public static String sanitizeTicketText(String txt) {
		PolicyFactory customPolicy = new HtmlPolicyBuilder()
			    .allowElements("li")
			    .allowElements("ul")
			    .allowElements("ol")
		    	.allowElements("p")
				.allowStandardUrlProtocols()
				.allowElements("a")
				.allowAttributes("href").onElements("a")
				.allowAttributes("target").matching(true, "_blank").onElements("a")
			    .requireRelNofollowOnLinks()
			    .toFactory();
		PolicyFactory policy = Sanitizers.FORMATTING.and(customPolicy);

		return policy.sanitize(txt);
	}
}
