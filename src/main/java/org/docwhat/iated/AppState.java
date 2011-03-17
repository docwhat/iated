/*
 */
package org.docwhat.iated;

import com.sun.jersey.api.container.httpserver.HttpServerFactory;
import com.sun.net.httpserver.HttpServer;
import java.io.File;
import java.io.IOException;
import java.net.ServerSocket;
import java.util.HashMap;
import java.util.Map;
import java.util.Set;
import java.util.prefs.Preferences;
import org.apache.commons.exec.CommandLine;
import org.apache.commons.exec.DefaultExecutor;
import org.apache.commons.exec.ExecuteException;
import org.apache.commons.exec.Executor;
import org.apache.commons.exec.OS;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 *
 * @author Christian Höltje
 * @author Jim Hurne
 */
public enum AppState {
    /** This a trick to have a singleton AppState.
     */
    INSTANCE;

    /** Setup logging for this class.
     */
    private static final Logger logger = LoggerFactory.getLogger(AppState.class);

    /** Constant for the editor in the preferences.
     */
    public static final String EDITOR = "EDITOR";
    /** Constant for the port number in the preferences.
     */
    public static final String PORT = "PORT";
    private Preferences store;
    private HttpServer server;
    private Map<String, EditSession> sessions = new HashMap<String, EditSession>();

    private AppState() {
        store = Preferences.userNodeForPackage(this.getClass());
    }

    /**
     * This should only be used for tests!!
     *
     * @param pref The Preferences object to use instead of the default.
     */
    public AppState instrumentForTests(Preferences pref) {
        store = pref;
        return this;
    }

    public void startServer() {
        if (null == server) {
            int defaultPort = this.getPort();
            String endpoint = String.format("http://localhost:%d/", defaultPort);
            logger.debug("Starting server on " + endpoint);

            try {
                server = HttpServerFactory.create(endpoint);
            }
            catch (IOException ex) {
                // TODO The user should be notified why the server didn't start.
                logger.error("Unable to start server", ex);
            }

            if (null != server) {
                server.start();
            } else {
                logger.debug("Server failed to start.");
            }
        } else {
            logger.debug("Starting server, but it was already started.");
        }
    }

    public void stopServer() {
        if (null != server) {
            logger.debug("Stopping server");
            server.stop(1);
            server = null;
        } else {
            logger.debug("Stopping server, but it was already stopped.");
        }
    }

    public void restartServer() {
        //TODO Don't restart if stopped
        stopServer();
        startServer();
    }

    public boolean isServerRunning() {
        return server != null;
    }

    public int getActivePort() {
        if (null == server) {
            return getPort();
        } else {
            return server.getAddress().getPort();
        }
    }

    /** gets the port number for the server.
     *
     * @return the port number for the server.
     */
    public int getPort() {
        try {
            int portNum = store.getInt(PORT, findFreePort());
            store.putInt(PORT, portNum);

            return portNum;
        } catch (IOException e) {
            //TODO Add a meaningful subclass?
            throw new RuntimeException(e);
        }
    }

    public void setPort(int port) {
        store.putInt(PORT, port);
        if (port != getActivePort()) {
            restartServer();
        }
    }

    public String getEditor() {
        String editor;

        editor = store.get(EDITOR, "");
        if (null == editor || "".equals(editor)) {
            if (OS.isFamilyMac()) {
                editor = "/Applications/TextEdit.app";
            } else if (OS.isFamilyUnix()) {
                editor = "gvim";
            } else if (OS.isFamilyWindows() || OS.isFamilyWin9x()) {
                editor = "notepad.exe";
            } else {
                editor = "";
            }
        }
        return editor;
    }

    public String editFile(File file) {
        String editor = getEditor();
        CommandLine cmd;

        if (OS.isFamilyMac() && editor.matches(".*\\.app")) {
            cmd = new CommandLine("/usr/bin/open");
            cmd.addArgument("-a").addArgument(editor).addArgument(file.toString());
        } else {
            cmd = new CommandLine(editor);
            cmd.addArgument(file.toString());
        }

        Executor executor = new DefaultExecutor();
        try {
            executor.execute(cmd);
        } catch (ExecuteException ex) {
            //TODO Do something meaningful with the exception.
            throw new RuntimeException(ex);
        } catch (IOException ex) {
            //TODO Do something meaningful with the exception.
            throw new RuntimeException(ex);
        }
        return "bogus-token";
    }

    /** Stores the editor to use.
     *
     * @param editor The string to save for the editor.
     */
    public void setEditor(final String editor) {
        store.put(EDITOR, editor);
    }

    /** get the base directory for saving text to.
     *
     * @return The directory where we save to.
     */
    public File getSaveDir() {
        return new File(System.getProperty("user.home") + "/.iat/");
    }

    /** Find a free TCP port.
     *
     * From:
     * http://stackoverflow.com/questions/2675362/how-to-find-an-available-port
     * http://stackoverflow.com/questions/3265825/finding-two-free-tcp-ports
     *
     * @return A free socket number.
     * @throws IOException If not free port can be found.
     */
    public int findFreePort() throws IOException {
        ServerSocket socket = null;

        try {
            socket = new ServerSocket(0);
            return socket.getLocalPort();
        } catch (Exception e) {
            throw new IOException("no free port found");
        } finally {
            if (socket != null) {
                socket.close();
            }
        }
    }

    /**
     * A hack needed by EditSession until it can be hooked into a DB.
     *
     * @param key The key to lookup the EditSession for.
     * @return The EditSession referred to by that key or null.
     */
    public EditSession hackGetEditSession(final String key) {
        if (sessions.containsKey(key)) {
            return sessions.get(key);
        } else {
            return null;
        }
    }

    /**
     * A hack to list all sessions.
     */
    public Set<String> hackGetAllSessionKeys() {
        return sessions.keySet();
    }

    /**
     * A hack needed by EditSession until it can be hooked into a DB.
     *
     * @param key
     * @param value
     */
    public void hackPutEditSession(String key, EditSession value) {
        sessions.put(key, value);
    }

    /**
     * Gets an edit session.
     *
     * @param url       The URL of the page needed.
     * @param id        The textarea id.
     * @param extension The extension of the file desired.
     * @return Returns an existing or new EditSession.
     */
    public EditSession getEditSession(String url, String id, String extension) {
        return EditSession.getSession(url, id, extension);
    }

    /**
     * Gets an edit session.
     *
     * @param token    The token of the session.
     * @return An EditSession or null.
     */
    public EditSession getEditSession(String token) {
        return EditSession.getSession(token);
    }
}
