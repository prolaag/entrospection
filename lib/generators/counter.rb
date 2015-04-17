#!/usr/bin/env ruby

# This test shows that our statistical analysis of entropy can detect something
# like a counter (which clearly has an even distribution of bits and bytes)
# interleaved into the stream of random bytes.

# This case demonstrates the utility of the "runs" test.

require_relative '../generator.rb'

class CounterGenerator < Generator

  def initialize(*args)
    super(*args)
    @i = 0
    @lcg = 0
    @skip = 0
  end

  def summary
    "Interleaves a counter into the stream of random bytes"
  end

  def description
    desc = <<-DESC_END
    This generator interleaves a counter, which clearly has an even
    distribution of bits and bytes, into the stream of random bytes. 
    This stream demonstrates the utility of the "runs" test.
    DESC_END
    desc.gsub(/\s+/, " ").strip
  end

  def next_chunk
    @skip = (@i + @skip) % 17 + 1
    @lcg = (@lcg * 6364136223846793005 + 1442695040888963407) % 2**64
    @i += @skip
    ((@i % 256).chr + [@lcg].pack('Q>'))
  end

end

CounterGenerator.run if __FILE__ == $0

