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
package org.docwhat.iated.rest;

import java.awt.EventQueue;

import javax.swing.JFrame;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;

import org.docwhat.iated.ui.PreferencesDialog;

/**
 * The /preferences resource
 * @author Christian Höltje
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
