package org.docwhat.iated.rest;

import java.awt.EventQueue;

import javax.swing.JFrame;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;

import org.docwhat.iated.ui.PreferencesDialog;

/**
 * The /preferences resource
 */
@Path("/preferences")
public class Preferences {

	/**
	 * Holds a reference to the preferences dialog (when displayed). Used to
	 * ensure that only one dialog is ever displayed.
	 */
	private static PreferencesDialog dialog;

	@GET
	@Produces("text/plain")
	public String showPreferencesDialog() {
		// Any interactions with Swing components needs to be done on the
		// AWT Event Thread.
		EventQueue.invokeLater(new Runnable() {
			public void run() {
				if (dialogIsNotVisible()) {
					dialog = new PreferencesDialog(new JFrame(), true);
					dialog.setVisible(true);
				}
			}
		});
		return "";
	}

	/**
	 * Determines if the preferences dialog box is currently being displayed. If
	 * the dialog box has not yet been created, then this method returns
	 * <code>true</code>.
	 * 
	 * @return <code>true</code> if the dialog is not currently visible,
	 *         otherwise <code>false</code>
	 */
	private static boolean dialogIsNotVisible() {
		return dialog == null || !dialog.isVisible();
	}
}
