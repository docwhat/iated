/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package org.docwhat.iated;

import junit.framework.TestCase;

/**
 *
 * @author docwhat
 */
public class AppStateTest extends TestCase {

  public AppStateTest(String name) {
    super(name);
  }

  public void testFindFreePort() throws Exception {
      int port = AppState.INSTANCE.findFreePort();
      assertTrue(port > 0);
  }
}
