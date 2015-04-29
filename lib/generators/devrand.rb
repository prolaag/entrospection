#!/usr/bin/env ruby

# Reads 128 bytes per chunk per request from the /dev/random device
# node (which will block until there is proper entropy).

require_relative '../generator.rb'

class DevRandomGenerator < Generator
  def initialize(*args)
    super(*args)
    @random = File.open("/dev/random")
  end

  def finalize(*args)
    @random.close()
  end

  def self.summary
    "Reads 128 bytes at a time from the /dev/random device file"
  end

  def self.description
    desc = <<-DESC_END
      This generator uses the /dev/random device to generate completely
      random (inasmuch as the kernel and your hardware provide) noise. However,
      there is some concern that if your kernel enables RDRAND support for
      /dev/random (and the rumors around Intel introducing a purposeful
      backdoor are ture), it may not be entirely non-deterministic afterall!
    DESC_END
    desc.gsub(/\s+/, " ").strip
  end

  def next_chunk
    return @random.read(128)
  end
end

DevRandomGenerator.run if __FILE__ == $0

