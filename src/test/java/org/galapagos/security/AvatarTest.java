package org.galapagos.security;

import java.io.File;
import java.io.IOException;

import org.galapagos.config.RootConfig;
import org.galapagos.config.SecurityConfig;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;

import net.coobird.thumbnailator.Thumbnails;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(classes = {
	RootConfig.class,
	SecurityConfig.class
})
public class AvatarTest {
	public static final String AVATAR_UPLOAD_DIR = "c:/upload/avatar";
	@Test
	public void testUpload() throws IOException {
		String username = "unknown";
		
		File src = new File("c:/temp/unknown.jpg");
		File dest = new File(AVATAR_UPLOAD_DIR, username + ".png");
		
		Thumbnails.of(src)
			.size(50, 50)
			.toFile(dest);
		
	}

}
