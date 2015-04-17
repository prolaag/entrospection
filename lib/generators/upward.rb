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

  def summary
    "A pseudo-random sequence that nudges 0.5% of the bytes updwards to produce demonstrable skew"
  end

  def description
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
    ret = ''
    ret << Digest::MD5.digest([@i].pack('Q>'))
    md5 = Digest::MD5.digest([@i].pack('Q<'))
    msb = md5[0].ord
    ret << md5[0] = ('%08b' % msb).reverse.to_i(2).chr if msb < 43
    ret
  end

end

UpwardGenerator.run if __FILE__ == $0

