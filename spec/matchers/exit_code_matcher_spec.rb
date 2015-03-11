require 'spec_helper'

module BlueShell
  module Matchers
    describe ExitCodeMatcher, :ruby19 => true do
      let(:expected_code) { 0 }

      subject { ExitCodeMatcher.new(expected_code) }

      describe "#matches?" do
        context "with something that isn't a runner" do
          it "raises an exception" do
            expect {
              subject.matches?("c'est ne pas une specker runner")
            }.to raise_exception(Errors::InvalidInputError)
          end
        end

        context "with a valid runner" do
          context "and the command exited with the expected exit code" do
            it "returns true" do
              BlueShell::Runner.run("true") do |runner|
                subject.matches?(runner).should be_truthy
              end
            end
          end

          context "and the command exits with a different exit code" do
            it "returns false" do
              BlueShell::Runner.run("false") do |runner|
                subject.matches?(runner).should be_falsey
              end
            end
          end

          context "and the command runs for a while" do
            it "waits for it to exit" do
              BlueShell::Runner.run("sleep 0.5") do |runner|
                subject.matches?(runner).should be_truthy
              end
            end
          end
        end
      end

      context "failure messages" do
        context "with a command that's exited" do
          it "has a correct failure message" do
            BlueShell::Runner.run("false") do |runner|
              subject.matches?(runner)
              runner.wait_for_exit
              subject.failure_message.should == "expected process to exit with status 0, but it exited with status 1"
            end
          end

          it "has a correct negative failure message" do
            BlueShell::Runner.run("false") do |runner|
              subject.matches?(runner)
              runner.wait_for_exit
              subject.negative_failure_message.should == "expected process to not exit with status 0, but it did"
            end
          end
        end

        context "with a command that's still running" do
          it "waits for it to exit" do
            BlueShell::Runner.run("ruby -e 'sleep 1; exit 1'") do |runner|
              subject.matches?(runner)
              subject.failure_message.should == "expected process to exit with status 0, but it exited with status 1"
            end
          end
        end
      end
    end
  end
end
