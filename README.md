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

## API

#### Ping

Verify that the server is running.

`GET /ping`

Returns the string `pong`.

### Send a file to the editor

`POST /edit` requires `auth-token`.

Arguments:

extension
: Extension for the file.
text
: The text.
url
: The URL for the text.
id
: The textarea id or identifier.

Returns a token or `fail`.

### Retrieve the result of an edit

`GET /edit/<token>` requires `auth-token`.

Returns:
document
: If the document has changed.
`nochange`
: If the document hasn't changed.
`fail`
: If the token isn't valid or some other error has happened.

### Open preferences

`GET /preferences` requires `auth-token`.

Returns `ok` or `fail`.

### Authenticate/Token Exchange

`GET /hello`

Returns `ok`.

IATed pops up a dialog box saying that someone is trying to access
IATed and has a 6 digit number to enter into the web browser to allow
access.  Similar to bluetooth connections.

`GET /hello` with auth=NNNNNN

If this is passed in, then the popup goes away and an `auth-token` is
returned.

## Example sessions.

The letter `b:` is the browser's requests. `s:` is the server's
response.  Side-effects are in square braces (`[]`).

### Initial authentication

    b: GET /hello
    s: ok [a popup with a six digit number is shown]
    b: GET /hello?auth=<NNNNNN>
    s: auth-token=<MMMMMMMMMMMMMMMMM>

### Editing session

    b: POST /edit text=<textarea data> url=<someurl> id=<textarea-id>
    s: <token>
    b: GET /edit/<token>
    s: nochange
    b: GET /edit/<token>
    s: <next textarea data>

## Java Notes

### JAX-RS

Using the [Jersey](http://jersey.java.net/) implementation of
JAX-RS. The API is in the java.ws.rs.* package.

