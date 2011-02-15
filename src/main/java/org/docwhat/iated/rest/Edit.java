/*
 */
package org.docwhat.iated.rest;

import java.io.File;
import java.io.IOException;
import javax.ws.rs.*;
import javax.ws.rs.core.MediaType;
import org.apache.commons.io.FileUtils;

import org.docwhat.iated.AppState;

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

        //TODO If any values are missing and the request is not an XHR request, then show a form for debugging/testing.

        AppState state = new AppState();
        File editFile = state.getSaveFile(url, id, extension);
        String token = "fail";
        try {
            FileUtils.write(editFile, text);
            token = state.editFile(editFile);
        }
        catch (IOException ex) {
            //TODO Do something meaningful with the exception.
            throw new RuntimeException(ex);
        }

        return token;
    }
}
