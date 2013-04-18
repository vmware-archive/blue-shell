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
    it "does not wait the full timeout if the command has already exited" do
      begin_time = Time.now
      Thread.new() do
        sleep(2)
        write.close
      end
      subject.send(:output_ended?, 10).should be_true
      duration = Time.now - begin_time

      duration.should <= 5
    end

    it "handles non-integer timeouts" do
      expect { subject.send(:output_ended?, 0.1) }.to_not raise_error
    end

    it "waits the full timeout when no output is arriving" do
      begin_time = Time.now
      Thread.new() do
        sleep(3)
        write.puts("not done")
      end
      subject.send(:output_ended?, 2).should be_true
      duration = Time.now - begin_time

      duration.should < 3
      duration.should >= 1.9
    end

    it "returns false if the output is readable" do
      begin_time = Time.now
      Thread.new() do
        sleep(1)
        write.puts("not done")
      end
      subject.send(:output_ended?, 4).should be_false
      duration = Time.now - begin_time

      duration.should <= 2
    end
  end
end
