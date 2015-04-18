#!/usr/bin/env ruby

# This generates a pseudo-random sequence by MD5-hashing an integer counter,
# but nudges 0.5% of the bytes updwards to produce demonstrable skew.

# This case demonstrates the utility of the "runs" test.

require_relative '../generator.rb'
require 'digest/md5'

class UpwardGenerator < Generator

  def initialize(*args)
    super(*args)
    @i = 0
  end

  def self.summary
    "MD5 output skewed towards higher byte values"
  end

  def self.description
    desc = <<-DESC_END
       This generates a pseudo-random sequence by MD5-hashing 
       an integer counter, but nudges 0.5% of the bytes updwards 
       to produce demonstrable skew. This case demonstrates the 
       utility of the "runs" test.
    DESC_END
    desc.gsub(/\s+/, " ").strip
  end

  def next_chunk
    @i += 1
    pristine = Digest::MD5.digest([@i].pack('Q>'))
    nudged = Digest::MD5.digest([@i].pack('Q<'))
    msb = nudged[0].ord
    nudged[0] = ('%08b' % msb).reverse.to_i(2).chr if msb < 43
    pristine << nudged
  end

end

UpwardGenerator.run if __FILE__ == $0

