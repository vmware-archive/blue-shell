require "spec_helper"

describe BlueShell::BufferedReaderExpector do
  let(:pipe) { IO::pipe }
  let(:read) { pipe[0] }
  let(:write) { pipe[1] }

  subject { BlueShell::BufferedReaderExpector.new(read) }

  describe "#read_to_end" do
    it "captures the output" do
      hash = %w|the never ending story|
      hash.each do |thing|
        write.puts thing
      end

      subject.read_to_end.should include(hash.last)

      hash.each do |thing|
        subject.output.should include(thing)
      end
    end
  end
end
