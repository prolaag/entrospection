#!/usr/bin/env ruby

# This implements the RC4 stream cipher
# Code adapted from https://en.wikipedia.org/wiki/RC4#Pseudo-random_generation_algorithm_.28PRGA.29
# License for the above at https://en.wikipedia.org/wiki/Wikipedia:Text_of_Creative_Commons_Attribution-ShareAlike_3.0_Unported
# I make no guarantees that this is in any way correct...

require_relative '../generator.rb'

class RC4 < Generator

  def initialize(*args)
    super(*args)
    # Here @r is the random number generated - i, j, and s are used to store RC4 states
    @r = 0
    @i = 0
    @j = 0
    # Key length of 5 = 40 bits
    key = *(1..5)
    # Initialize the array
    @s = *(0..255)
    y = 0
    for x in 0..255
      y = (y + @s[x] + key[x % key.length]) % 256
      @s[x], @s[y] = @s[y], @s[x]
    end
  end

  def self.summary
    "8-bit RC4 PRGA"
  end

  def self.description
    desc = <<-DESC_END
    This generates an 8-bit pseudo-random sequence using an RC4 stream cipher using a hardcoded 40-bit key. Not 
    cryptographically secure, but perhaps a little interesting.
    DESC_END
    desc.gsub(/\s+/, " ").strip
  end

  def rc4()
    @i = (@i + 1) % 256
    @j = (@j + @s[@i]) % 256
    @s[@i], @s[@j] = @s[@j], @s[@i]
    return @s[(@s[@i] + @s[@j]) % 256]
  end
    
  def next_chunk
    @r = rc4()
    ([@r].pack('C'))
  end

end

RC4.run if __FILE__ == $0
