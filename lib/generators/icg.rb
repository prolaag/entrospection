#!/usr/bin/env ruby

# This generates a pseudo-random sequence by using the an inverse
# congruential generation method

require_relative '../generator.rb'
require 'prime'

class IcgGenerator < Generator
  def initialize(*args)
    super(*args)
    @a = 32416190071  #prime multiplier
    @x = 123456789    #x_0 seed value
    @c = 5            #arbitrary constant
    @q = 4294967291   #mod prime
  end

  def self.summary
    "Inverse congruential pseudo random number generator"
  end

  def self.description
    desc = <<-DESC_END
      This generator uses an inverse congruential method of computing
      pseudo random numbers.
    DESC_END
    desc.gsub(/\s+/, " ").strip
  end


  def next_chunk
    @x = (@a * ~@x + @c ) % @q
    [ @x ].pack('C')
  end

end

IcgGenerator.run if __FILE__ == $0

