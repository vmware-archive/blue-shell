require 'spec_helper'

module BlueShell
  describe Matchers do
    include Matchers

    describe "#say" do
      it "returns an ExpectOutputMatcher" do
        say("").should be_a(Matchers::OutputMatcher)
      end

      it "has synonyms" do
        have_output("").should be_a(Matchers::OutputMatcher)
      end

      context "with an explicit timeout" do
        it "returns an ExpectOutputMatcher" do
          matcher = say("", 30)
          matcher.should be_a(Matchers::OutputMatcher)
          matcher.timeout.should == 30
        end
      end
    end

    describe "#have_exited_with" do
      it "returns an ExitCodeMatcher" do
        have_exited_with(1).should be_a(Matchers::ExitCodeMatcher)
      end

      it "has synonyms" do
        exit_with(1).should be_a(Matchers::ExitCodeMatcher)
        have_exit_code(1).should be_a(Matchers::ExitCodeMatcher)
      end
    end
  end
end
