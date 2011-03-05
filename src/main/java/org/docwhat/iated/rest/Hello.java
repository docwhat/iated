/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package org.docwhat.iated.rest;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;

/**
 *
 * @author Christian Hšltje
 */
@Path("/hello")
public class Hello {

    @GET
    @Produces(MediaType.TEXT_PLAIN)
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public String hello() {
        //TODO begin authentication handshake.
        //TODO popup a six-digit number in a dialog box.
        return "ok";
    }

    @POST
    @Produces(MediaType.TEXT_PLAIN)
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public String hello(@FormParam("auth") String auth) {
        //TODO complete authentication handshake with auth.
        return "Your Authentication Token";
    }

}
