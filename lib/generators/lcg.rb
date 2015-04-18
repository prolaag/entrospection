#!/usr/bin/env ruby

# This test shows that LCG (Linear congruential generator) pseudo-random number
# generation produces output that can be detected as non-random by the inline
# statistical tests.

# This case demonstrates the utility of the "q-independence" test.

require_relative '../generator.rb'

class LcgGenerator < Generator


  def initialize(*args)
    super(*args)
     @i = 0
  end

  def self.summary
    "64-bit linear congruential generator (LCG)"
  end

  def self.description
    desc = <<-DESC_END
    The LCG pseudo-random number generatior produces output that can be detected as 
    non-random by the inline statistical tests. This emonstrates the utility of
    the "q-independence" test.
    DESC_END
    desc.gsub(/\s+/, " ").strip
  end

  def next_chunk
    @i = (@i * 6364136223846793005 + 1442695040888963407) % 2**64
    ([@i].pack('Q>'))
  end
end

LcgGenerator.run if __FILE__ == $0
