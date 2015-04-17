#!/usr/bin/env ruby

# This generates a pseudo-random sequence by MD5-hashing an integer counter.

require_relative '../generator.rb'
require 'digest/md5'

class Md5Generator < Generator

  def initialize(*args)
    super(*args)
    @i = 0
  end

  def summary
    "A pseudo-random sequence by MD5-hashing an integer counter"
  end

  def description
    desc = <<-DESC_END
      This generates a pseudo-random sequence by MD5-hashing an integer counter.
    DESC_END
    desc.gsub(/\s+/, " ").strip
  end


  def next_chunk
    @i += 1
    Digest::MD5.digest([@i].pack('Q>'))
  end

end

Md5Generator.run if __FILE__ == $0

