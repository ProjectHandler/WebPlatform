package fr.projecthandler.util;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;

import javax.imageio.ImageIO;
import javax.persistence.Query;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.IOUtils;
import org.imgscalr.Scalr;
import org.imgscalr.Scalr.Method;
import org.imgscalr.Scalr.Mode;
import org.apache.commons.lang.StringUtils;
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
				log.error("error in writeFileAsResponseStream during copy", e);
			} finally {
				if (in != null) {
					try {
						in.close();
					} catch (IOException e) {
						log.error("error in writeFileAsResponseStream during close", e);
					}
				}
			}
		}
	}

	public static void writeFileAsResponseStreamWithFileName(File file, HttpServletResponse response, String otherFileName) {
		if (file != null) {
			response.setHeader("Content-Disposition", "attachment;filename=" + otherFileName);

			FileInputStream in = null;
			try {
				in = new FileInputStream(file);
				IOUtils.copy(in, response.getOutputStream());
			} catch (Exception e) {
				log.error("error in writeFileAsResponseStream during copy", e);
			} finally {
				if (in != null) {
					try {
						in.close();
					} catch (IOException e) {
						log.error("error in writeFileAsResponseStream during close", e);
					}
				}
			}
		}
	}

	public static String truncate(String str, int length) {
		if (!StringUtils.isEmpty(str) && str.length() > length)
			str = str.substring(0, length);
		return str;
	}

	/**
	 * Utility method used to fetch Class list based on a package name.
	 * 
	 * @param packageName
	 *            should be the package containing your annotated beans.
	 */
	public static List<Class<?>> getClasses(String packageName) throws Exception {
		File directory = null;
		try {
			ClassLoader cld = getClassLoader();
			URL resource = getResource(packageName, cld);
			directory = new File(resource.toURI());
		} catch (NullPointerException ex) {
			throw new ClassNotFoundException(packageName + " (" + directory + ") does not appear to be a valid package");
		}
		return collectClasses(packageName, directory);
	}

	private static ClassLoader getClassLoader() throws ClassNotFoundException {
		ClassLoader cld = Thread.currentThread().getContextClassLoader();
		if (cld == null) {
			throw new ClassNotFoundException("Can't get class loader.");
		}
		return cld;
	}

	private static URL getResource(String packageName, ClassLoader cld) throws ClassNotFoundException {
		String path = packageName.replace('.', '/');
		URL resource = cld.getResource(path);
		if (resource == null) {
			throw new ClassNotFoundException("No resource for " + path);
		}
		return resource;
	}

	private static List<Class<?>> collectClasses(String packageName, File directory) throws ClassNotFoundException {
		List<Class<?>> classes = new ArrayList<Class<?>>();
		if (directory.exists()) {
			String[] files = directory.list();
			if (files != null) {
				for (String file : files) {
					if (file.endsWith(".class")) {
						// removes the .class extension
						classes.add(Class.forName(packageName + '.' + file.substring(0, file.length() - 6)));
					}
				}
			}
		} else {
			throw new ClassNotFoundException(packageName + " is not a valid package");
		}
		return classes;
	}

}