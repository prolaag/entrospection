#!/usr/bin/env ruby

require_relative '../generator.rb'
require 'digest/md5'

class TaylorGenerator < Generator

  def initialize(*args)
    super(*args)
    @i = 0
    @b = 1
    @t = 2
  end

  def self.summary
    "Simple random number generator that keeps state in three variables."
  end

  def self.description
    desc = <<-DESC_END
      This generates a pseudo-random sequence by Taylor-hashing an integer counter.
    DESC_END
    desc.gsub(/\s+/, " ").strip
  end

  def next_chunk
    @b = (@b + @i) % 256
    @i = @i + @b + @t + 3
    @t = (@t * (@b + 1)) % 1102031013030304
  
   return @b.chr

 end

end

TaylorGenerator.run if __FILE__ == $0

