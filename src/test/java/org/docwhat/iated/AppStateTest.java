/*
 * IATed -- It's All Text! Editor Daemon
 * Copyright (C) 2010,2011  Christian Höltje
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
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
