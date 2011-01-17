/*
 */
package org.docwhat.iated.rest;

import java.io.File;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.ws.rs.Consumes;
import javax.ws.rs.DefaultValue;
import javax.ws.rs.FormParam;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import org.apache.commons.io.FileUtils;

import org.docwhat.iated.AppState;

/**
 *
 * 
 */
@Path("/edit")
public class Edit {

    @POST
    @Produces("text/plain")
    @Consumes("application/x-www-form-urlencoded")
    public String edit(
            @DefaultValue("") @FormParam("token") String token,
            @DefaultValue("txt") @FormParam("extension") String extension,
            @DefaultValue("") @FormParam("content") String content) {

        System.out.println("Editing:");
        System.out.println("Token:" + token);
        System.out.println("Extension:" + extension);
        System.out.println("Content:" + content);

        AppState state = new AppState();
        File editFile = new File(state.getSaveDir(), token + "." + extension);
        try {
            FileUtils.write(editFile, content);
            state.editFile(editFile);
        }
        catch (IOException ex) {
            //TODO Do something meaningful with the exception.
            throw new RuntimeException(ex);
        }

        return token;
    }

}
