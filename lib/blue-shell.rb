module BlueShell
  class << self
    attr_accessor :timeout

    def with_timeout(timeout)
      old_timeout = self.timeout
      self.timeout = timeout
      yield
    ensure
      self.timeout = old_timeout
    end
  end

  self.timeout = 30
end

require 'blue-shell/errors'
require 'blue-shell/matchers'
require 'blue-shell/matchers/exit_code_matcher'
require 'blue-shell/matchers/output_matcher'
require 'blue-shell/runner'
require 'blue-shell/buffered_reader_expector'
