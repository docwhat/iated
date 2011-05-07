# It's All Text! Editor Daemon

This is a server that will open text data in the editor of your
choice.

It is based on HTTP, so that it can be used in an ajax style by
plugins (or conceivably web pages).

## Bugs and Issues

See [the github Issue tracker](https://github.com/docwhat/iated/issues)

## Project Tracking

See
[the Pivotal Tracker for It's All Text!](https://www.pivotaltracker.com/projects/178151).

## Developer Quickstart

1. Install [RVM](https://rvm.beginrescueend.com/) in your user
account.
2. Install jruby-1.6.1: `rvm install jruby-1.6.1`
3. Install bundler: `gem install bundler`
4. Install all the rest of the gems: `bundle`
5. You can now use rake to build things. :-)

Hint: You can run `jruby --ng-server` in one window and then set
`export JRUBY_OPTS=--ng` in another and all the jruby processes will
use nail-gun to start faster.  Though this can produce weird effects
at time.  An example is that sinatra can only be "control-c"''d from
the nail-gun server shell, not the shell you ran iated from.

## API

#### Ping

Verify that the server is running.

`GET /ping`

Returns the string `pong`.

### Send a file to the editor

`POST /edit` requires "token".

Arguments:

extension
: Extension for the file.
text
: The text.
url
: The URL for the text.
id
: The textarea id or identifier.

Returns a "sid" or `fail`.

### Retrieve the result of an edit

`GET /edit/<sid>` requires "token".

Returns:
document
: If the document has changed.
`nochange`
: If the document hasn't changed.
`fail`
: If the token isn't valid or some other error has happened.

### Open preferences

`GET /preferences` requires "token".

Opens a web-page displaying the preferences.  Note, there are other
URLs that IATed supports for modifying the preferences.

`GET /preferences/set-editor` require "token".

This opens  a dialog on the system running IATed to choose the editor.

### Authenticate/Token Exchange

`GET /hello`

Returns `ok`.

IATed pops up a dialog box saying that someone is trying to access
IATed and has a 4 digit number (the "secret")to enter into the web browser to allow
access.  Similar to bluetooth connections.

`POST /hello` with secret=/[0-9]{4}/

If this is passed in, then the popup goes away and the "token" is returned.

## Example sessions.

The letter `b:` is the browser's requests. `s:` is the server's
response.  Side-effects are in square braces (`[]`).

### Initial authentication

    b: GET /hello
    s: ok [a popup with the secret is shown]
    b: POST /hello with data: secret=NNNN
    s: token=<MMMMMMMMMMMMMMMMM>

### Editing session

    b: POST /edit text=<textarea data> url=<someurl> id=<textarea-id>
    s: <sid>
    b: GET /edit/<sid>
    s: nochange
    b: GET /edit/<sid>
    s: <next textarea data>

## IATed Dialogs

This is a list of dialogs that IATed needs to be able to generate:

* Set Editor -- The dialog to select an editor.
* Auth Code -- A dialog to show the auth-code for entering in the
  browser.
* Select Port -- A dialog to select the port to run on for the first
  time or if changing.
