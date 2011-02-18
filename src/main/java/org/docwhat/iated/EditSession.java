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
    Boolean created;

    EditSession(
            AppState init_state,
            String init_url,
            String init_id,
            String init_extension) {
        state = init_state;
        url = init_url;
        id = init_id;
        extension = init_extension;
        created = false;
    }

    //TODO I need a factory method to hydrate an EditSession or create a new one.

    /**
     *
     * @returns true if an edit session with these parameters exists.
     */
    public boolean exists() {
        return false;
    }

    public boolean edit(String text) {
        created = false;
        File editFile = state.getSaveFile(url, id, extension);
        try {
            FileUtils.write(editFile, text);
            state.editFile(editFile);
            created = true;
        }
        catch (IOException ex) {
            //TODO Do something meaningful with the exception.
            throw new RuntimeException(ex);
        }
        return created;
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
