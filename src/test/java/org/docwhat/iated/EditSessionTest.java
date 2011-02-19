package org.docwhat.iated;


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

}
