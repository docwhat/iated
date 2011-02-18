/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.docwhat.iated;

import java.io.File;
import java.io.IOException;
import org.apache.commons.io.FileUtils;

/**
 *
 * @author docwhat
 */
public class EditSession {

    AppState state;
    String url;
    String id;
    String extension;

    EditSession(
            AppState init_state,
            String init_url,
            String init_id,
            String init_extension) {
        state = init_state;
        url = init_url;
        id = init_id;
        extension = init_extension;
    }

    //TODO I need a factory method to hydrate an EditSession or create a new one.

    /**
     *
     * @returns true if an edit session with these parameters exists.
     */
    public boolean exists() {
        //TODO implement EditSession.exists()
        return false;
    }

    public boolean create(String text) {
        File editFile = state.getSaveFile(url, id, extension);
        String token = "fail";
        try {
            FileUtils.write(editFile, text);
            state.editFile(editFile);
        }
        catch (IOException ex) {
            //TODO Do something meaningful with the exception.
            throw new RuntimeException(ex);
        }
        return true; //TODO return based whether it was created or not.
    }

    /**
     *
     * @returns the token for this session.
     */
    public String getToken() {
        //TODO implement EditSession.getToken()
        return "TODO-123";
    }
}
