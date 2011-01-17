/*
 */
package org.docwhat;

import java.io.IOException;
import java.net.ServerSocket;

/**
 *
 * 
 */
public class Preferences {

  public int getPort() throws IOException {
      return findFreePort();
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
