/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.docwhat.iated.rest;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;

/**
 *
 * @author docwhat
 */
@Path("/edit/{token}")
public class EditToken {

    @GET
    @Produces(MediaType.TEXT_PLAIN)
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public String edit(@PathParam("token") String token) {
        System.out.println("Editing:");
        System.out.println(" ... checking token: " + token);

        return "nochange";
    }
}
