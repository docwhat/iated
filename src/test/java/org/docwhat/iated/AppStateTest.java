/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package org.docwhat.iated;

import java.util.prefs.Preferences;

import org.junit.Before;

import junit.framework.TestCase;

/**
 *
 * @author Christian Höltje
 */
public class AppStateTest extends TestCase {

    public AppStateTest(String name) {
        super(name);
    }

    @Before
    public void setUp() throws Exception {
        AppState.INSTANCE.instrumentForTests(Preferences.userNodeForPackage(this.getClass()));
    }

    public void testFindFreePort() throws Exception {
        int port = AppState.INSTANCE.findFreePort();
        assertTrue(port > 0);
    }

    public void testGetPort() throws Exception {
        AppState state = AppState.INSTANCE;
        state.setPort(123);
        assertEquals(state.getPort(), 123);
        state.setPort(321);
        assertEquals(state.getPort(), 321);

    }
}
