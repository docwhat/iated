# It's All Text! Editor Daemon

This is a server that will open text data in the editor of your
choice.

It is based on HTTP, so that it can be used in an ajax style by
plugins (or conceivably web pages).

## API

Token is determined by the client. I recommend you use something like
SHA or MD5 on some unique data.  Worst case scenario, you can ask for
a token via the API.

#### Ping

Verify that the server is running.

`GET /ping`

Returns the string 'pong'.

### Get a token

`GET /token`

Returns a token as a string.

### Send a file to the editor

`POST to /edit/<token>`
d
Returns 'ok' or 'fail'.

### Retrieve the result of an edit

`GET /edit/<token>`

### Open preferences

`GET /preferences`

### Send Document

### Does Document Exist?

### Get Document

#### ... Only If Changed Since ...

### Authenticate/Token Exchange

`GET /hello`

Pops up a "do you want to allow the user to connect to IATed"
display. If the user agrees, then it returns an auth token.

If not, then it returns nothing.

The auth token should be used as a POST argument in the form:
`auth=NNNN`

