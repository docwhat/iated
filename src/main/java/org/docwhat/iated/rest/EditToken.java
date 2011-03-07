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
 * @author Christian Höltje
 */
@Path("/edit/{token}")
public class EditToken {
    private static final Logger logger = LoggerFactory.getLogger(EditToken.class);

    @GET
    @Produces(MediaType.TEXT_PLAIN)
    public Response GET(@PathParam("token") String token) {
        EditSession session = AppState.INSTANCE.getEditSession(token);

        logger.debug("Session: " + token);
        if (null == session) {
            logger.debug("No such session: " + AppState.INSTANCE.hackGetAllSessionKeys().toString());
            return Response.status(404).build();
        } else {
            logger.debug("ChangeID: " + session.getChangeId());

            Map<String, String> response = new LinkedHashMap<String, String>();
            response.put("id",   session.getChangeId().toString());
            response.put("text", session.getText());

            return Response.ok(response, MediaType.APPLICATION_JSON).build();
        }

    }
}
