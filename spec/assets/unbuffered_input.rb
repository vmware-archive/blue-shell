#!/usr/bin/env ruby

require 'io/wait'
require_relative '../../spec/support/escaped_keys'

class UnbufferedInput
  $stdout.sync = true

  def initialize(exit_on_character)
    @exit_on_character = exit_on_character
    puts "started"
    result = read_input
    puts %Q{received: #{result.inspect}} if result
  end

  class << self
    alias_method :run, :new
  end


  def read_input
    begin
      system("stty raw -echo -icanon isig <&2")

      line = ""
      input_character = ""

      escaped = false
      exit_on = ""
      while exit_on != @exit_on_character
        input_character = $stdin.getc

        exit_on << input_character if escaped

        if input_character == "\e"
          escaped = true
        end

        line << input_character
      end
      line
    ensure
      system "stty -raw echo" # turn raw input off
    end
  end
end

exit_on_character = ARGF.argv[0]
UnbufferedInput.run(exit_on_character)
