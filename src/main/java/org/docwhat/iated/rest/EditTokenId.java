package org.docwhat.iated.rest;

import java.util.LinkedHashMap;
import java.util.Map;

import javax.ws.rs.DefaultValue;
import javax.ws.rs.FormParam;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.docwhat.iated.AppState;
import org.docwhat.iated.EditSession;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Path("/edit/{token}/{id}")
public class EditTokenId {
    private static final Logger logger = LoggerFactory.getLogger(EditTokenId.class);

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    public Response GET(@PathParam("token") String token,
                        @PathParam("id")    Long   id) {

        EditSession session = AppState.INSTANCE.getEditSession(token);
        Long change_id = session.getChangeId();

        boolean has_changed = change_id != id;

        logger.debug("--EditTokenId");
        logger.debug("Session: " + token);
        logger.debug("ChangeId: " + change_id);
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
