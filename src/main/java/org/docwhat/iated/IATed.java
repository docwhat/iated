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
import org.simplericity.macify.eawt.Application;
import org.simplericity.macify.eawt.ApplicationEvent;
import org.simplericity.macify.eawt.ApplicationListener;
import org.simplericity.macify.eawt.DefaultApplication;

/**
 *
 * @author docwhat
 */
public class IATed implements ApplicationListener {

    private JFrame dashboard;
    private AppState state;
    private Application application;
    private static final String APP_NAME = "IATed";

    public static void main(String[] args) {
        Application application = new DefaultApplication();
        IATed iated = new IATed();
        iated.setApplication(application);
        iated.init();
    }

    private void setApplication(Application application) {
        this.application = application;
    }

    public void init() {

        application.addApplicationListener(this);
        application.addPreferencesMenuItem();
        application.setEnabledPreferencesMenu(true);

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

    public void handleAbout(ApplicationEvent event) {
        //aboutAction.actionPerformed(null);
        event.setHandled(true);
    }

    public void handleOpenApplication(ApplicationEvent event) {
        if(event.getFilename() != null) {
            //openFileInEditor(new File(event.getFilename()));
        }
    }

    public void handleOpenFile(ApplicationEvent event) {
        //openFileInEditor(new File(event.getFilename()));
    }

    public void handlePreferences(ApplicationEvent event) {
        //preferencesAction.actionPerformed(null);
    }

    public void handlePrintFile(ApplicationEvent event) {
//        JOptionPane.showMessageDialog(this, "Sorry, printing not implemented");
    }

    public void handleQuit(ApplicationEvent event) {
        state.stopServer();
        System.out.println("NARF: Goodbye!");
        System.exit(0);
    }

    public void handleReOpenApplication(ApplicationEvent event) {
        System.out.println("NARF!");
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
