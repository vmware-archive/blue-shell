# BlueShell [![Gem Version](https://badge.fury.io/rb/blue-shell.png)](http://badge.fury.io/rb/blue-shell)

Friendly command-line test runner and matchers for shell scripting in ruby using RSpec.

## Installation

With Bundler, add the following to your Gemfile:

```ruby
group :test do
  gem "blue-shell"
end
```

Then require and configure BlueShell in your `spec_helper.rb`:

```ruby
require 'blue-shell'

RSpec.configure do |c|
  c.include BlueShell::Matchers
end
```

## Usage

### Running commands

Shell commands in BlueShell get executed by creating a new runner instance `BlueShell::Runner.run`.
Running a command by default times out after 5 seconds or raises a `Timeout::Error`.

```ruby
BlueShell::Runner.run 'sleep 1' # success
BlueShell::Runner.run 'sleep 6' # fails with Timeout::Error
```

### Expectations on exit codes

```ruby
BlueShell::Runner.run 'false' do |runner|
  runner.should exit_with 1
  runner.should have_exit_code 1 # #exit_with and #have_exit_code are aliases
end
```

### Expectations on STDOUT

```ruby
BlueShell::Runner.run 'echo "foo bar baz"' do |runner|
  runner.should say 'foo'
  runner.should have_output 'bar' # #say and #have_output are aliases
end
```

By default `#say` and `#have_output` will smartly wait a maximum of 30 seconds.
If you need to increase that timeout, you can do so:

```ruby
BlueShell::Runner.run 'sleep 35 && echo "foo bar baz"' do |runner|
  runner.should have_output 'bar', 40
end
```

### Interacting with STDIN

```ruby
BlueShell::Runner.run 'read' do |runner|
  runner.send_keys 'foo'
end

BlueShell::Runner.run 'read' do |runner|
  runner.send_return
end
```

### About timeouts...

Within the run block you can call `#wait_for_exit` (default 5 seconds) if you want to make sure your
command finishes within that time.

```ruby
BlueShell::Runner.run 'sleep 6' do |runner|
  runner.wait_for_exit 7
end
```

It is important to note the difference between calling `.run` 'one-off' vs passing in a block:

```ruby
# raises a Timeout::Error after 5 seconds
BlueShell::Runner.run 'sleep 60'

# succeeds
BlueShell::Runner.run 'sleep 60' do |_|
  # unless #wait_for_exit or #have_exit_code are invoked
  # your specs do not wait for the command to exit
  # and also do not fail if it never does
end
```

That being said, in most cases you probably want to invoke `#wait_for_exit` or `#have_exit_code`
at the end of your block to ensure the command finishes.

## Credits

BlueShell is maintained and funded by [Pivotal Labs](http://www.pivotallabs.com).
Thank you to all the [contributors](https://github.com/pivotal/blue-shell/contributors).

Copyright
---------
Copyright &copy; Pivotal Labs. See [LICENSE](https://raw.github.com/pivotal/blue-shell/master/LICENSE) for details.
