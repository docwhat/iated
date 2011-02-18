/*
 */
package org.docwhat.iated.rest;

import java.io.File;
import java.io.IOException;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import org.apache.commons.io.FileUtils;

import org.docwhat.iated.AppState;
import org.docwhat.iated.EditSession;

/**
 *
 * 
 */
@Path("/edit")
public class Edit {

    @POST
    @Produces(MediaType.TEXT_PLAIN)
    @Consumes(MediaType.APPLICATION_FORM_URLENCODED)
    public String edit(
            @DefaultValue("") @FormParam("url") String url,
            @DefaultValue("") @FormParam("id") String id,
            @DefaultValue("txt") @FormParam("extension") String extension,
            @FormParam("text") String text) {
        //TODO edit should require auth-token.

        System.out.println("Editing:");
        System.out.println("Url:" + url);
        System.out.println("Id:" + id);
        System.out.println("Extension:" + extension);
        System.out.println("Content:" + text);

        AppState state = AppState.INSTANCE;
        EditSession session = state.getEditSession(url, id, extension);
        if (session.exists()) {
            return "exists";
        } else if (session.create(text)) {
            return session.getToken();
        } else {
            return "fail";
        }
    }
}
