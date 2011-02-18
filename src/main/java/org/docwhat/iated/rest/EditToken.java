/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.docwhat.iated.rest;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import org.docwhat.iated.AppState;
import org.docwhat.iated.EditSession;

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
        EditSession session = AppState.INSTANCE.getEditSession(token);

        System.out.println("--EditToken");
        System.out.println("Session: " + token);

        return session.getText();
    }
}
