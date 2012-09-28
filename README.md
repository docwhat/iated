# It's All Text! Editor Daemon

[![Build Status](https://secure.travis-ci.org/docwhat/iated.png)](http://travis-ci.org/docwhat/iated)

This gem is the core of the *It's All Text! Editor Daemon*.

The *IAT Editor Daemon* is a restful web server that allows you to
open text data in the editor of your choice.

## WARNING WARNING WARNING

This is still being designed and developed!  You probably don't want to play with it (YET)!!!

## Bugs and Issues

See [the github Issue tracker](https://github.com/docwhat/iated/issues)

## Developer Quickstart

1. `bundle install`
2. `rake spec`

### Requirements

* Ruby (preferrably 1.9.2+, but 1.8.7 should work)

## API

The API is documented in the `features/extension_*.feature` files. You
can run cucumber to read them.

### Open preferences

`GET /preferences` requires "token".

Opens a web-page displaying the preferences.  Note, there are other
URLs that Iated supports for modifying the preferences.

`GET /preferences/set-editor` require "token".

This opens  a dialog on the system running Iated to choose the editor.

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

## Iated Dialogs

This is a list of dialogs that Iated needs to be able to generate:

* Set Editor -- The dialog to select an editor.
* Auth Code -- A dialog to show the auth-code for entering in the
  browser.
* Select Port -- A dialog to select the port to run on for the first
  time or if changing.


## Future notes

At some point I'm going to need concurrancy.  I'm thinking
[jetlang](http://code.google.com/p/jetlang/) (a java library) is the
right way to go.  It's Erlang style concurrancy, so it'll scale well
and should be safe without having to worry about joins, etc.  There is
a ruby gem called [jretlang](http://github.com/reevesg/jretlang)

Some info here:

* [Concurrancy models in JRuby using jetlang](http://www.blog.wordaligned.com/2010/02/17/concurrency-models-in-jruby-using-jetlang/)
* [What is erlang style concurrency?](http://ulf.wiger.net/weblog/2008/02/06/what-is-erlang-style-concurrency/)
* [LWN article](http://lwn.net/Articles/441790/)

## License

Iated is licensed under the
[MIT License](http://www.opensource.org/licenses/mit-license.php). A
`LICENSE` file should have been included with this code.
