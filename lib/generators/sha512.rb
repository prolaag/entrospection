#!/usr/bin/env ruby

require_relative '../generator.rb'

require 'digest'

class SHA512Generator < Generator
  def initialize(*args)
    super(*args)
    @i = 0
  end

  def self.summary
    "SHA2 hash with a 512-byte bit length"
  end

  def self.description
    desc = <<-DESC_END
      This generator uses Ruby's built-in SHA2 digest provider class to
      deterministically increment a counter from which a hexdigest is
      generated.
    DESC_END
    desc.gsub(/\s+/, " ").strip
  end

  def next_chunk
    @i += 1
    return Digest::SHA2.new(512).hexdigest([@i].pack("C"))
  end
end

SHA512Generator.run if __FILE__ == $0

