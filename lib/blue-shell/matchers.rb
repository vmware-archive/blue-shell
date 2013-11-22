module BlueShell
  module Matchers
    def say(expected_output)
      OutputMatcher.new(expected_output)
    end

    alias :have_output :say

    def have_exited_with(expected_code)
      ExitCodeMatcher.new(expected_code)
    end

    alias :have_exit_code :have_exited_with
    alias :exit_with :have_exited_with
  end
end
