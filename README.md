# It's All Text! Editor Daemon

This is a server that will open text data in the editor of your
choice.

It is based on HTTP, so that it can be used in an ajax style bye
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
4. Install all the rest of the gems: `bundle install -p .bundle`
5. You can now use rake to build things. :-)
6. View the static docs with `rake yard`  and point your browser at
the `target/doc/index.html` file
7. Dynamically view the docs with `bundle exec yard server --reload`

### Nail Gun

You can run `jruby --ng-server` in one window and then set
`export JRUBY_OPTS=--ng` in another and all the jruby processes will
use nail-gun to start faster.

This *can*  produce weird effects.  An example is that sinatra can
only be sent `control-c`  from the nail-gun server shell, not the
shell you ran the sinatra process  from. I've also had problems with
bundler not behaving correctly.

### "client" instead of "server" optimizations

Another option is to specify the "client" optimizations instead of
"server" optimizations.  The server stuff takes longer to start, but
runs much higher performance once it gets up to speed.

You won't need this for the bulk of development, so you can turn it
off by setting `export JAVA_OPTS="-d32"`.  You are supposed to have this work
by setting `-client`, but that never works for me on OS-X.

### Turning off the JRuby JIT compiler

You can turn off the compilation of ruby stuff by using the `-X-C`
flag for jruby.  You can set this with `export
JRUBY_OPTS="-X-C"`. With server class processes this is desirable, but
with development, we don't care.

### Other ideas

See Headius's [JRuby Startup Time tips](http://blog.headius.com/2010/03/jruby-startup-time-tips.html).

## Developing for IATed

Thanks for taking the time to try building IATed!

### Requirements

* A Unix style OS (e.g. OS X or Linux)
* Java 1.6
* [RVM](https://rvm.beginrescueend.com/)

### First time setup

Add these lines to your `~/.rvmrc` file (create it if it doesn't exist):

    rvm_install_on_use_flag=1
    rvm_project_rvmrc=1
    rvm_gemset_create_on_use_flag=1

`cd` into checkout and you should see RVM install the correct JRuby.

Then install bundler:

    gem install bundler

And tell bundler to install the rest of the gems:

    bundle install --path .bundle

### The ./bin directory

The top level `bin` directory can be a useful alternative to prefixing
all commands with `bundle exec`. It was added for the CI system, but
can be used during normal development to prevent the double executions
of JRuby that `bundle exec` causes.

Because you can't set environment
variables from within JRuby, the path stuff may not work
unless you add the `bin` directory to your `PATH`.

For example:

    env PATH="$(pwd)/bin:${PATH}" bin/rake ci

## API

The API is documented in the `features/extension_*.feature` files. You
can run cucumber to read them.

### Open preferences

`GET /preferences` requires "token".

Opens a web-page displaying the preferences.  Note, there are other
URLs that IATed supports for modifying the preferences.

`GET /preferences/set-editor` require "token".

This opens  a dialog on the system running IATed to choose the editor.

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

IATed is licensed under the
[MIT License](http://www.opensource.org/licenses/mit-license.php). A
LICENSE should have been included with this code.
