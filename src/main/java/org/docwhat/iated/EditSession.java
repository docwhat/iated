/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.docwhat.iated;

import java.io.File;
import java.io.IOException;

import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 *
 * @author Christian H�ltje
 * @author Jim Hurne
 */
public class EditSession {
    private static final Logger logger = LoggerFactory.getLogger(EditSession.class);

    String url;
    String id;
    String extension;
    private File file;
    private Long lastModified;
    private Long fileSize;
    private Long changeId;

    EditSession(
            String init_url,
            String init_id,
            String init_extension) {
        url = init_url;
        id = init_id;
        extension = init_extension;
        file = null;
        changeId = -1L;
    }

    /**
     * Returns a unique key for the HashMap on AppState.
     *
     * In the future, we'll use the DB to look this up or assign a new
     * unique one.
     *
     * @param url The URL of the page. Optional.
     * @param id  The id of the TextArea.
     * @param ext The file extension desired.
     * @return A unique key for this specific set of values.
     */
    public static String getToken(String url, String id, String ext) {
        return "TOKEN" + url + "@@@" + id + "@@@" + ext;
    }

    /**
     * Factory method for retrieving the correct session.
     *
     * @param url The URL of the page. Optional.
     * @param id  The id of the TextArea.
     * @param ext The file extension desired.
     * @return An existing edit session or a new edit session.
     */
    public static EditSession getSession(String url, String id, String ext) {
        AppState state = AppState.INSTANCE;
        String token = EditSession.getToken(url, id, ext);
        EditSession session = state.hackGetEditSession(token);
        if (session == null) {
            session = new EditSession(url, id, ext);
            state.hackPutEditSession(token, session);
        }
        return session;
    }

    /**
     * Retrieves the session based on the token.
     *
     * @param token The token of the EditSession.
     * @return The matching EditSession or null.
     */
    static EditSession getSession(String token) {
        return AppState.INSTANCE.hackGetEditSession(token);
    }

    /**
     *
     * @return true if an edit session with these parameters exists.
     */
    public boolean exists() {
        return false;
    }

    public boolean edit(String text) {
        AppState state = AppState.INSTANCE;
        file = state.getSaveFile(url, id, extension);
        try {
            FileUtils.write(file, text);
            state.editFile(file);
            getChangeId();
        } catch (IOException ex) {
            //TODO Do something meaningful with the exception.
            file = null;
            throw new RuntimeException(ex);
        }
        return file != null;
    }

    /**
     *
     * @return the token for this session.
     */
    public String getToken() {
        //TODO This needs to be stored or fetched from the db.
        return EditSession.getToken(url, id, extension);
    }

    public String getText() {
        File editFile = AppState.INSTANCE.getSaveFile(url, id, extension);
        try {
            return FileUtils.readFileToString(editFile);
        } catch (IOException ex) {
            //TODO Handle this better.
            throw new RuntimeException(ex);
        }
    }

    /** gets the number of the current change.
     *
     * @return the number of the current change.
     */
    public Long getChangeId() {
        logger.debug("Change Number for " + getToken() + " was " + changeId + "...");

        if (file != null) {
            if (lastModified == null || fileSize == null ||
                (lastModified != file.lastModified() && fileSize != file.length())) {
                changeId = changeId + 1;
                lastModified = file.lastModified();
                fileSize = file.length();
            }
        }
        logger.debug("Change Number for " + getToken() + " is now " + changeId);
        return changeId;
    }
}
