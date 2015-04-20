#!/usr/bin/env ruby

# This generates a pseudo-random sequence with Marsaglia's MWC

require_relative '../generator.rb'

class MwcGenerator < Generator

  def initialize(*args)
    super(*args)
    @z = 362436069
    @w = 521288629
  end

  def self.summary
    "Marsaglia's 16-bit multiple-with-carry pseudo-random number generator"
  end

  def self.description
    desc = <<-DESC_END
      This generates a pseudo-random sequence by using Marsaglia's 16-bit
      multiply-with-carry. This is not cryptographically secure, but it is 
      quite fast.
    DESC_END
    desc.gsub(/\s+/, " ").strip
  end

  # From the late George Marsaglia
  # http://www.cse.yorku.ca/~oz/marsaglia-rng.html
  def next_chunk
    mwc = (new_z << 16) + new_w
    [mwc].pack('L>')
  end

  private

  def new_z
    @z = 36969 * (@z & 0xffff) + (@z >> 16)
  end

  def new_w
    @w = 18000 * (@w & 0xffff) + (@w >> 16)
  end

end

MwcGenerator.run if __FILE__ == $0

