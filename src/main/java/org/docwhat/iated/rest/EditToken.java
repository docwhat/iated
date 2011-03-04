/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.docwhat.iated.rest;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import org.docwhat.iated.AppState;
import org.docwhat.iated.EditSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 *
 * @author docwhat
 */
@Path("/edit/{token}")
public class EditToken {
    private static final Logger logger = LoggerFactory.getLogger(EditToken.class);

    @GET
    @Produces(MediaType.TEXT_PLAIN)
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public String edit(@PathParam("token") String token) {
        EditSession session = AppState.INSTANCE.getEditSession(token);

        logger.debug("--EditToken");
        logger.debug("Session: " + token);

        return session.getText();
    }
}
