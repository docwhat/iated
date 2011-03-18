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


import java.io.File;
import java.util.prefs.Preferences;
import junit.framework.TestCase;
import org.junit.Before;

public class EditSessionTest extends TestCase{

    @Before
    public void setUp() throws Exception {
        AppState.INSTANCE.instrumentForTests(Preferences.userNodeForPackage(this.getClass()));
    }

    public void testGetToken() throws Exception {
        assertFalse(EditSession.getToken("url1", "id1", "txt1").equals(EditSession.getToken("url1", "id1", "txt2")));
        assertFalse(EditSession.getToken("url1", "id1", "txt1").equals(EditSession.getToken("url1", "id2", "txt1")));
        assertFalse(EditSession.getToken("url1", "id1", "txt1").equals(EditSession.getToken("url2", "id1", "txt1")));
    }

    public void testGetSaveFile() throws Exception {
        EditSession a = new EditSession(
                "http://somesite.example.com/the/full/path?query=string",
                "id",
                "extension"
                );
        File f = a.getSaveFile();
        assertTrue("File should not have http in it: " + f.toString(),
                    f.toString().indexOf("http") == -1);
        assertTrue("File should end with .extension: " + f.toString(),
                    f.toString().endsWith(".extension"));
        assertTrue("File dirname should start with somesite: " + f.getParentFile().getName(),
                    f.getParentFile().getName().startsWith("somesite"));
        assertTrue("File basename should start with 'the': " + f.getName(),
                    f.getName().startsWith("the"));
    }

}
