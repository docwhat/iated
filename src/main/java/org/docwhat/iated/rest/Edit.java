/*
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
 * @author Christian Hšltje
 */
@Path("/edit")
public class Edit {
    private static final Logger logger = LoggerFactory.getLogger(Edit.class);

    @POST
    @Produces(MediaType.TEXT_PLAIN)
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public String edit(
            @DefaultValue("") @FormParam("url") String url,
            @DefaultValue("") @FormParam("id") String id,
            @DefaultValue("txt") @FormParam("extension") String extension,
            @FormParam("text") String text) {
        //TODO edit should require auth-token.

        logger.debug("--Edit");
        logger.debug("Editing:");
        logger.debug("Url:" + url);
        logger.debug("Id:" + id);
        logger.debug("Extension:" + extension);
        logger.debug("Content:" + text);

        AppState state = AppState.INSTANCE;
        EditSession session = state.getEditSession(url, id, extension);
        if (session.exists()) {
            return "exists";
        } else if (session.edit(text)) {
            return session.getToken();
        } else {
            return "fail";
        }
    }
}
