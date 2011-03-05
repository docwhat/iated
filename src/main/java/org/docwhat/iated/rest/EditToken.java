/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.docwhat.iated.rest;

import java.util.LinkedHashMap;
import java.util.Map;

import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.docwhat.iated.AppState;
import org.docwhat.iated.EditSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 *
 * @author Christian Hšltje
 */
@Path("/edit/{token}")
public class EditToken {
    private static final Logger logger = LoggerFactory.getLogger(EditToken.class);

    @GET
    @Produces(MediaType.TEXT_PLAIN)
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public String GET(@PathParam("token") String token) {
        EditSession session = AppState.INSTANCE.getEditSession(token);

        logger.debug("--EditToken");
        logger.debug("Session: " + token);

        return session.getText();
    }

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public Response GET(@PathParam("token") String token,
            @DefaultValue("0") @FormParam("id") Number id) {

        EditSession session = AppState.INSTANCE.getEditSession(token);
        Number change_id = session.getChangeId();

        boolean has_changed = change_id != id;

        logger.debug("--EditToken (HEAD)");
        logger.debug("Session: " + token);
        logger.debug("Has Changed: " + has_changed);

        if (has_changed) {
            Map<String, String> response = new LinkedHashMap<String, String>();
            response.put("id",   change_id.toString());
            response.put("text", session.getText());

            return Response.ok(response, MediaType.APPLICATION_JSON).build();
        } else {
            return Response.notModified().build();
        }
    }
}
