module BlueShell
  module Matchers
    class OutputMatcher
      attr_reader :timeout

      def initialize(expected_output, timeout = 30)
        @expected_output = expected_output
        @timeout = timeout
      end

      def matches?(runner)
        raise Errors::InvalidInputError unless runner.respond_to?(:expect)
        @matched = runner.expect(@expected_output, @timeout)
        @full_output = runner.output
        !!@matched
      end

      def failure_message
        if @expected_output.is_a?(Hash)
          expected_keys = @expected_output.keys.map{|key| "'#{key}'"}.join(', ')
          "expected one of #{expected_keys} to be printed, but it wasn't. full output:\n#@full_output"
        else
          "expected '#{@expected_output}' to be printed, but it wasn't. full output:\n#@full_output"
        end
      end

      def negative_failure_message
        if @expected_output.is_a?(Hash)
          match = @matched
        else
          match = @expected_output
        end

        "expected '#{match}' to not be printed, but it was. full output:\n#@full_output"
      end
    end
  end
end
