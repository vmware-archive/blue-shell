module BlueShell
  module Matchers
    class ExitCodeMatcher
      def initialize(expected_code)
        @expected_code = expected_code
      end

      def matches?(runner)
        raise Errors::InvalidInputError unless runner.respond_to?(:exit_code)

        begin
          Timeout.timeout(BlueShell.timeout) do
            @actual_code = runner.exit_code
          end

          @actual_code == @expected_code
        rescue Timeout::Error
          @timed_out = true
          false
        end
      end

      def failure_message
        if @timed_out
          "expected process to exit with status #@expected_code, but it did not exit within 5 seconds"
        else
          "expected process to exit with status #{@expected_code}, but it exited with status #{@actual_code}"
        end
      end

      def negative_failure_message
        if @timed_out
          "expected process to exit with status #@expected_code, but it did not exit within 5 seconds"
        else
          "expected process to not exit with status #{@expected_code}, but it did"
        end
      end
    end
  end
end
