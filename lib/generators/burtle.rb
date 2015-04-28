#!/usr/bin/env ruby

# This generates a pseudo-random sequence by using the deterministic pseudo-
# random number generator built into Ruby

require_relative '../generator.rb'

class BurtleGenerator < Generator
  def initialize(*args)
    super(*args)

    seed = 0xbeeff00d
    @a = 0xf1ea5eed
    @b = @c = @d = seed
    20.times do
      next_chunk
    end
  end

  def self.summary
    "A Ruby implementation of Bob Jenkins' 'Small Non-Cryptographic PRNG'"
  end

  def self.description
    desc = <<-DESC_END
      This Ruby implementation of Bob Jenkins' 'Small Non-Cryptographic PRNG'
      was sourced from:
      http://www.burtleburtle.net/bob/rand/smallprng.html
    DESC_END
    desc.gsub(/\s+/, " ").strip
  end

  def next_chunk
    e = (@a - rot(@b, 27)) & 0xffffffff
    @a = (@b ^ rot(@c, 17)) & 0xffffffff
    @b = (@c + @d) & 0xffffffff
    @c = (@d + e) & 0xffffffff
    @d = (e + @a) & 0xffffffff
    [ @d ].pack('L>')
  end

  private

  def rot(val, bits)
    (((val << bits) | (val >> (32 - bits))) & 0xffffffff)
  end

end

BurtleGenerator.run if __FILE__ == $0

