require 'spec_helper'

module BlueShell
  module Matchers
    describe OutputMatcher, :ruby19 => true do
      let(:expected_output) { "expected_output" }

      subject { OutputMatcher.new(expected_output) }

      before { allow(BlueShell).to receive(:timeout).and_return(1) }

      describe "#matches?" do
        context "with something that isn't a runner" do
          it "raises an exception" do
            expect {
              subject.matches?("c'est ne pas une specker runner")
            }.to raise_exception(Errors::InvalidInputError)
          end
        end

        context "with a valid runner" do
          context "when the expected output is in the process output" do
            it "finds the expected output" do
              BlueShell::Runner.run("echo -n expected_output") do |runner|
                expect(subject.matches?(runner)).to be(true)
              end
            end
          end

          context "when the expected output is not in the process output" do
            let(:runner) { Runner.new('echo -n not_what_we_were_expecting') }

            it "does not find the expected output" do
              BlueShell::Runner.run("echo -n not_what_we_were_expecting") do |runner|
                expect(subject.matches?(runner)).to be(false)
              end
            end
          end
        end
      end

      context "failure messages" do
        it "has a correct failure message" do
          BlueShell::Runner.run("echo -n actual_output") do |runner|
            subject.matches?(runner)
            expect(subject.failure_message).to eq("expected 'expected_output' to be printed, but it wasn't. full output:\nactual_output")
          end
        end

        it "has a correct negative failure message" do
          BlueShell::Runner.run("echo -n actual_output") do |runner|
            subject.matches?(runner)
            expected_message = "expected 'expected_output' to not be printed, but it was. full output:\nactual_output"
            expect(subject.failure_message_when_negated).to eq(expected_message)
            expect(subject.negative_failure_message).to eq(expected_message)
          end
        end

        context "when expecting branching output" do
          let(:expected_output) { {
            "expected_output" => proc {},
            "other_expected_output" => proc {}
          } }

          it "has a correct failure message" do
            BlueShell::Runner.run("echo -n actual_output") do |runner|
              subject.matches?(runner)
              expect(subject.failure_message).to eq("expected one of 'expected_output', 'other_expected_output' to be printed, but it wasn't. full output:\nactual_output")
            end
          end

          it "has a correct negative failure message" do
            BlueShell::Runner.run("echo -n expected_output") do |runner|
              subject.matches?(runner)
              expected_message = "expected 'expected_output' to not be printed, but it was. full output:\nexpected_output"
              expect(subject.failure_message_when_negated).to eq(expected_message)
              expect(subject.negative_failure_message).to eq(expected_message)
            end
          end
        end
      end
    end
  end
end
