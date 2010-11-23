package org.gerf.iated;

import java.io.IOException;

import com.sun.jersey.api.container.httpserver.HttpServerFactory;
import com.sun.net.httpserver.HttpServer;

/**
 * The Main class. Spins up the Java 6 embedded HTTP server to serve the REST resources.
 */
@SuppressWarnings("restriction")
public class Main {

	public static void main(String args[]) throws IOException {
		HttpServer server = HttpServerFactory.create("http://localhost:9090/");
		
		server.start();
		
		System.out.println("Daemon running. Hit enter to exit...");
		System.in.read();
		
		System.out.print("Shutting daemon down...");
		
		server.stop(0);
		System.out.println("done.");
		System.exit(0);
	}
}
