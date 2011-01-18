/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.docwhat.iated;

import javax.swing.JFrame;
import javax.swing.SwingUtilities;
import javax.swing.UIManager;
import javax.swing.UnsupportedLookAndFeelException;
import org.docwhat.iated.ui.DashboardFrame;

/**
 *
 * @author docwhat
 */
public class IATed {

    private JFrame dashboard;
    private AppState state;
    private static final String APP_NAME = "IATed";

    public static void main(String[] args) {
        new IATed();
    }

    public IATed() {
        // Set some mac-specific properties. This must go before enabling swing.
        if (System.getProperty("mrj.version") != null) {
            System.setProperty("apple.awt.graphics.EnableQ2DX", "true");
            System.setProperty("apple.laf.useScreenMenuBar", "true");
            System.setProperty("com.apple.mrj.application.apple.menu.about.name", APP_NAME);
        }

        useSwingSystemLookAndFeel();

        SwingUtilities.invokeLater(new Runnable() {

            public void run() {
                // Set up the state.
                state = new AppState();

                // Start the server.
                state.startServer();

                // Start the UI.
                dashboard = new DashboardFrame(state);
                dashboard.setVisible(true);
            }
        });
    }

    /**
     * Set the Swing look-and-feel to the System look-and-feel. The System look
     * and feel ensures that Swing windows closely match the native OS windows.
     */
    private static void useSwingSystemLookAndFeel() {
        try {
            // Use the System (native) look and feel
            UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());

        }
        catch (UnsupportedLookAndFeelException e) {
            System.err.println("Unable to set the Swing Look and Feel. "
                    + "The default look and feel will be used instead.");
            e.printStackTrace();
        }
        catch (ClassNotFoundException e) {
            System.err.println("Unable to set the Swing Look and Feel. "
                    + "The default look and feel will be used instead.");
            e.printStackTrace();
        }
        catch (InstantiationException e) {
            System.err.println("Unable to set the Swing Look and Feel. "
                    + "The default look and feel will be used instead.");
            e.printStackTrace();
        }
        catch (IllegalAccessException e) {
            System.err.println("Unable to set the Swing Look and Feel. "
                    + "The default look and feel will be used instead.");
            e.printStackTrace();
        }
    }
}
