module BlueShell
  module Errors
    class InvalidInputError < StandardError; end

    class NonZeroExitCodeError < StandardError
      attr_reader :exit_code
      def initialize(exit_code)
        @exit_code = exit_code
      end
    end
  end
end
