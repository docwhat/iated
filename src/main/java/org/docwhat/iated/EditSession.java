/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.docwhat.iated;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Formatter;

import org.apache.commons.io.FileUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 *
 * @author Christian Höltje
 * @author Jim Hurne
 */
public class EditSession {
    private static final Logger logger = LoggerFactory
            .getLogger(EditSession.class);

    String url;
    String id;
    String extension;
    String token;
    private File file;
    private Long lastModified;
    private Long fileSize;
    private Long changeId;

    EditSession(String init_url, String init_id, String init_extension) {
        url = init_url;
        id = init_id;
        extension = init_extension;
        token = null;
        file = null;
        changeId = -1L;
    }

    /**
     *
     * @return the token for this session.
     * @throws NoSuchAlgorithmException
     * @throws UnsupportedEncodingException
     */
    public String getToken() {
        if (null == token) {
            token = EditSession.getToken(url, id, extension);
        }
        // TODO This needs to be stored or fetched from the db.
        return token;
    }

    /**
     * Returns a unique key for the HashMap on AppState.
     *
     * In the future, we'll use the DB to look this up or assign a new unique
     * one.
     *
     * @param url
     *            The URL of the page. Optional.
     * @param id
     *            The id of the TextArea.
     * @param ext
     *            The file extension desired.
     * @return A unique key for this specific set of values.
     * @throws UnsupportedEncodingException
     */
    public static String getToken(String url, String id, String ext) {
        MessageDigest md;
        try {
            try {
                md = MessageDigest.getInstance("MD5");
                md.update(("url: " + url).getBytes("UTF-8"));
                md.update(("id: " + id).getBytes("UTF-8"));
                md.update(("extension: " + ext).getBytes("UTF-8"));
                return byteArray2Hex(md.digest());
            } catch (NoSuchAlgorithmException e) {
                return java.net.URLEncoder.encode("TOKEN" + url + "@@@" + id
                        + "@@@" + ext, "UTF-8");
            }
        } catch (UnsupportedEncodingException e) {
            throw new RuntimeException(e);
        }
    }

    /** Method to convert bytes to a String.
     *
     * @param hash A set of bytes
     * @return a hex encoded String.
     */
    private static String byteArray2Hex(byte[] hash) {
        Formatter formatter = new Formatter();
        for (byte b : hash) {
            formatter.format("%02x", b);
        }
        return formatter.toString();
    }

    /**
     * Factory method for retrieving the correct session.
     *
     * @param url
     *            The URL of the page. Optional.
     * @param id
     *            The id of the TextArea.
     * @param ext
     *            The file extension desired.
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
     * @param token
     *            The token of the EditSession.
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
            // TODO Do something meaningful with the exception.
            file = null;
            throw new RuntimeException(ex);
        }
        return file != null;
    }

    public String getText() {
        File editFile = AppState.INSTANCE.getSaveFile(url, id, extension);
        try {
            return FileUtils.readFileToString(editFile);
        } catch (IOException ex) {
            // TODO Handle this better.
            throw new RuntimeException(ex);
        }
    }

    /**
     * gets the number of the current change.
     *
     * @return the number of the current change.
     */
    public Long getChangeId() {
        logger.debug("Change Number for " + getToken() + " was " + changeId
                + "...");

        if (file != null) {
            if (lastModified == null
                    || fileSize == null
                    || (lastModified != file.lastModified() && fileSize != file
                            .length())) {
                changeId = changeId + 1;
                lastModified = file.lastModified();
                fileSize = file.length();
            }
        }
        logger.debug("Change Number for " + getToken() + " is now " + changeId);
        return changeId;
    }
}
