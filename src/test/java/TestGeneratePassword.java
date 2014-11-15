import org.junit.Test;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;


public class TestGeneratePassword {
	
	@Test
	public void testGeneratePassword() {
		BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
		
		System.out.println("encrypted password: " + passwordEncoder.encode("toto"));
	}
}
