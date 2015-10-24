package fr.projecthandler.util;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.List;

import javax.imageio.ImageIO;
import javax.persistence.Query;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.imgscalr.Scalr;
import org.imgscalr.Scalr.Method;
import org.imgscalr.Scalr.Mode;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
public class Utilities {

	private static final Log log = LogFactory.getLog(Utilities.class);
			
	public static <T> T getSingleResultOrNull(Query query) {
		query.setMaxResults(1);
		List<T> list = query.getResultList();
		if (list.isEmpty()) {
			return null;
		}
		return list.get(0);
	}

	public static <T> T getSingleResultOrNullWithoutSettingMaxResults(Query query) {
		List<T> list = query.getResultList();
		if (list.isEmpty()) {
			return null;
		}
		return list.get(0);
	}

	public static String getRequestParameter(HttpServletRequest request, String parameter) {
		if (request.getParameter(parameter) != null && !"undefined".equals(request.getParameter(parameter))) {
			return request.getParameter(parameter);
		}
		return null;
	}

	public static File resizeImage(File fileInput, int width, int height) {
		File fileOutput = fileInput;
		try {
			// load image
			BufferedImage img = ImageIO.read(fileInput);

			// resize image
			if (img != null && (img.getWidth() > width || img.getHeight() > height)) {
				BufferedImage outImage = Scalr.resize(img, Method.QUALITY, Mode.AUTOMATIC, width, height, Scalr.OP_ANTIALIAS);
				ImageIO.write(outImage, "png", fileOutput);
			}
		} catch (IOException e) {
			log.error("error during resizing of image", e);
		}

		return fileOutput;
	}

	public static void writeFileAsResponseStream(File file, HttpServletResponse response) {
		if (file != null) {
			response.setHeader("Content-Disposition", "attachment;filename=" + file.getName());

			FileInputStream in = null;
			try {
				in = new FileInputStream(file);
				IOUtils.copy(in, response.getOutputStream());
			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				if (in != null) {
					try {
						in.close();
					} catch (IOException e) {
						log.error("error in writeFileAsResponseStream", e);
					}
				}
			}
		}
	}
}