/*
 */
package org.docwhat.iated;

import com.sun.jersey.api.container.httpserver.HttpServerFactory;
import com.sun.net.httpserver.HttpServer;
import java.io.File;
import java.io.IOException;
import java.net.ServerSocket;
import java.util.prefs.Preferences;

/**
 *
 * 
 */
public class AppState {
    public static final String EDITOR = "EDITOR";
  public static final String PORT = "PORT";

  private Preferences store;
  private HttpServer server;

  public AppState() {
      store = Preferences.userNodeForPackage(this.getClass());
  }
  
  public void startServer() {
        int defaultPort = this.getPort();
        String endpoint = String.format("http://localhost:%d/", defaultPort);

        try {
            server = HttpServerFactory.create(endpoint);
        } catch (IOException ex) {
            //Logger.getLogger(DashboardFrame.class.getName()).log(Level.SEVERE, null, ex);
            //TODO Add a meaningful subclass?
            throw new RuntimeException(ex);
        }

        server.start();
        System.out.println("Started server on: " + endpoint);
  }

  public void stopServer() {
      server.stop(0);
  }

  public void restartServer() {
      //TODO Don't restart if stopped
      stopServer();
      startServer();
  }

  public int getActivePort() {
      //TODO Catch Exception in the case where the server is not started
      return server.getAddress().getPort();
  }

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
      if(port != getActivePort()) {
        restartServer();
      }
  }

  public String getEditor() {
      return store.get(EDITOR,"");
  }

  public void setEditor(String editor) {
      store.put(EDITOR, editor);
  }

  public File getSaveDir() {
      return new File(System.getProperty("user.home") + "/.iat/");
  }

  public int findFreePort() throws IOException {
    // From http://stackoverflow.com/questions/2675362/how-to-find-an-available-port
    // Also see http://stackoverflow.com/questions/3265825/finding-two-free-tcp-ports
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

}
