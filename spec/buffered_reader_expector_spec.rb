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

  describe "output_ended?" do
    it "should not wait the full timeout if the command has already exited" do
      begin_time = Time.now
      Thread.new() do
        sleep(2)
        write.puts Net::EOF
      end
      subject.send(:output_ended?, 10)
      duration = Time.now - begin_time

      duration.should <= 5
    end

    it "should handle non-integer timeouts" do
      expect { subject.send(:output_ended?, 0.1) }.to_not raise_error
    end
  end
end
