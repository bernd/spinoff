# Spinoff

Spinoff will help you to speed up your Ruby test workflow.

It does that by preloading your environment and then using functions like
`fork` for each run of your test suite to avoid loading framework code
like Rails over and over again. (it supports JRuby as well)

# Credits

Lots of code has been taken from the [Spin](https://github.com/jstorimer/spin)
project by Jesse Storimer. Thanks for sharing, Jesse!

# How does it work

Spinoff operates with the assumption that most of the dependencies of your
application do not change. If you are working on a Rails project, you
probably do not have to reload all Rails classes for each test run.

The `spinoff-server` command starts a server process that will listen for
a list of test files on a unix domain socket. It will also load an init file
which contains all code that should be preloaded.
(like `require 'config/application'` for Rails)

The `spinoff-client` command will be called with a list of test files that
should be executed. It sends that file list to the server process via the
unix domain socket.

Once the server process receives a list of files, it will fork the Ruby process
and execute the files with the selected test runner. All code that changes
frequently will only be loaded in the forked process.

This allows Spinoff to speed up our test suite without any knowledge of the
frameworks and libraries we use to build our app.

# How is it different from Spin?

Spinoff is based on [Spin](https://github.com/jstorimer/spin) but differs on
the following points.

1. It is framework agnostic and thus needs an init file to preload code.
   Spin does only support Rails at this time of writing.

2. It works with [JRuby](http://www.jruby.org/)!

# Usage

Spinoff needs an init file to preload code. Please make sure you only load
libraries that do not change between your test runs. If you change anything
you preload in the init file, you have to restart the Spinoff server.

Example:

```ruby
ENV['RAILS_ENV'] = 'test'
require 'config/application'
require 'rspec'
```

Starting the server:

    $ spinoff-server --rspec config/spinoff.rb

Please use `spinoff-server --help` to show all available options.

Sending a list of test files to the server:

    $ spinoff-client spec/test1_spec.rb spec/foo/bar_spec.rb

Spinoff should work well with autotest(ish) tools. Just start the server and
execute the spinoff client on file changes.

# JRuby Support

Since JRuby does not support the fork system call, Spinoff is using a
new `ScriptingContainer` for each test run. That also means we cannot really
preload any code. But it saves us from starting a new JVM for each test run.

# Contributing

I'm happy about any kind of feedback and/or contribution.

# Caveats

* New and not well tested.
* No test suite yet.

# Author

[Bernd Ahlers](https://github.com/bernd)
