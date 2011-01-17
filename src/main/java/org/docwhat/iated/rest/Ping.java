package org.docwhat.iated.rest;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;

/**
 * The /ping resource.
 */
@Path("/ping")
public class Ping {
	
	@GET
	@Produces("text/plain")
	public String ping() {
		return "pong";
	}
}
