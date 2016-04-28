#!/usr/bin/env ruby

# This implements a 64-bit Xorshift* PRNG
# Code adapted from https://en.wikipedia.org/wiki/Xorshift#xorshift.2A
# License for the above at https://en.wikipedia.org/wiki/Wikipedia:Text_of_Creative_Commons_Attribution-ShareAlike_3.0_Unported_License

require_relative '../generator.rb'

class XorshiftStar < Generator

  def initialize(*args)
    super(*args)
    # Seed with 1 as 0 produces all zeroes
    @i = 1
  end

  def self.summary
    "64-bit xorshift* PRNG"
  end

  def self.description
    desc = <<-DESC_END
    This generates a non-cryptographically secure pseudo-random sequence by a 64-bit xorshift* generator (xorshift 
    times a modulus). This generator will produce a peroidicity of 2^64 - 1.
    DESC_END
    desc.gsub(/\s+/, " ").strip
  end

  def xorshift_star(x)
    x ^= x >> 12
    x ^= x << 25
    x ^= x >> 27
    return (x * 2685821657736338717) % 2**64
  end
    
  def next_chunk
    @i = xorshift_star(@i)
    [@i].pack('Q>')
  end

end
XorshiftStar.run if __FILE__ == $0
