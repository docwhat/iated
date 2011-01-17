# Stories

# Done
* User starts IATed and gets the dashboard.
* User presses preference button and gets the preference dialog.
* User preferences show default, and same as dashboard.
* Prefs: User changes port from default.
* Prefs: User changes port, presses save and the webserver is restarted on a new port.
* Prefs: User changes editor by typing path.
* User's browser sends `/edit` request to IATed and the editor is opened.
* Dashboard shows port number.
* Use a select to find an open default port in the range from 10,000-30,0000.

# Now
* Prefs: User changes editor by pressing 'select editor' button.
* Prefs: User changes savePath. Warning about closing all open editors should be shown and all files in old savePath should be moved.
* Dashboard shows url for cut-and-paste to browser.
* Dashboard shows requests.

# Backlog
* Prefs: When user 'selects editor', it should use a system appropriate path.
* Prefs: The default editor is system appropriate.
* Prefs: When user 'selects editor' a second time, it should use the previous directory as its starting point.
* User selects preference via menu.
* Icon for IATed.
* Proper application menu for IATed in menus/start-bar/etc.
* Prefs: As user changes port, it should validate against range ( > 1024, <= 65,535) and integerness.

# Icebox
* Prefs: Hitting enter should save by default.
* A user runs a second copy of IATed and it shows a message and quits.
* When a user requests the IATed preferences via a browser, the preferences should appear above the browser.
* Errors should go to a system appropiate log.
* User runs iated without a gui.
