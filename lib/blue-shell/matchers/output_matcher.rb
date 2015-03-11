module BlueShell
  module Matchers
    class OutputMatcher
      def initialize(expected_output)
        @expected_output = expected_output
      end

      def matches?(runner)
        raise Errors::InvalidInputError unless runner.respond_to?(:expect)
        @matched = runner.expect(@expected_output)
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

      def failure_message_when_negated
        if @expected_output.is_a?(Hash)
          match = @matched
        else
          match = @expected_output
        end

        "expected '#{match}' to not be printed, but it was. full output:\n#@full_output"
      end

      alias :negative_failure_message :failure_message_when_negated
    end
  end
end
