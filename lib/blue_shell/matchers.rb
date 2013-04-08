module BlueShell
  module Matchers
    def say(expected_output, timeout = 30)
      OutputMatcher.new(expected_output, timeout)
    end

    def have_exited_with(expected_code)
      ExitCodeMatcher.new(expected_code)
    end

    alias :exit_with :have_exited_with
  end
end
