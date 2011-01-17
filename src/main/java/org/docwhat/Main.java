package org.docwhat;

import java.io.IOException;

import javax.swing.UIManager;
import javax.swing.UnsupportedLookAndFeelException;

import com.sun.jersey.api.container.httpserver.HttpServerFactory;
import com.sun.net.httpserver.HttpServer;

/**
 * The Main class. Spins up the Java 6 embedded HTTP server to serve the REST
 * resources. Also sets the Swing look-and-feel (for the various UI components).
 */
@SuppressWarnings("restriction")
public class Main {

	public static void main(String args[]) throws IOException {
		useSwingSystemLookAndFeel();

		HttpServer server = HttpServerFactory.create("http://localhost:9090/");

		server.start();

		System.out.println("Daemon running. Hit enter to exit...");
		System.in.read();

		System.out.print("Shutting daemon down...");

		server.stop(0);
		System.out.println("done.");
		System.exit(0);
	}

	/**
	 * Set the Swing look-and-feel to the System look-and-feel. The System look
	 * and feel ensures that Swing windows closely match the native OS windows.
	 */
	private static void useSwingSystemLookAndFeel() {
		try {
			// Use the System (native) look and feel
			UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());

		} catch (UnsupportedLookAndFeelException e) {
			System.err.println("Unable to set the Swing Look and Feel. "
					+ "The default look and feel will be used instead.");
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			System.err.println("Unable to set the Swing Look and Feel. "
					+ "The default look and feel will be used instead.");
			e.printStackTrace();
		} catch (InstantiationException e) {
			System.err.println("Unable to set the Swing Look and Feel. "
					+ "The default look and feel will be used instead.");
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			System.err.println("Unable to set the Swing Look and Feel. "
					+ "The default look and feel will be used instead.");
			e.printStackTrace();
		}
	}
}
