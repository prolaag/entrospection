#!/usr/bin/env ruby

# This test generates a pseudo-random sequence by multiplying pi
# by an incrementing counter, dividing by e and sin of the product

require_relative '../generator.rb'

class PiEinTheSin < Generator

  def pimulti(i)
    i * Math::PI
  end

  def divE(num)
    num / Math::E
  end

  def initialize(*args)
    super(*args)
    @i = 0
  end

  def self.summary
    "Generates a PRN using algo Sin((Pi * i) / e )"
  end

  def self.description
    desc = <<-DESC_END
    This generatior produces a pseudo-random sequence by Sin((Pi * i) / e )
    DESC_END
    desc.gsub(/\s+/, " ").strip
  end


  def next_chunk
    @i += 1
    Math::sin(divE(pimulti(@i))).to_s
  end

end

PiEinTheSin.run if __FILE__ == $0
