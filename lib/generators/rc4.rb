#!/usr/bin/env ruby

# This implements a 64-bit Xorshift* PRNG
# Code adapted from https://en.wikipedia.org/wiki/RC4#Pseudo-random_generation_algorithm_.28PRGA.29
# License for the above at https://en.wikipedia.org/wiki/Wikipedia:Text_of_Creative_Commons_Attribution-ShareAlike_3.0_Unported

require_relative '../generator.rb'

class RC4 < Generator

  def initialize(*args)
    super(*args)
    # Here @r is the random number generated
    @r = 0
    @i = 0
    @j = 0
    @k = 0
    # Key length of 5 = 40 bits
    keylen = 5
    key = [1, 2, 3, 4, 5]
    # Initialize the array
    @s = Array.new
    for x in 0..255
      @s[x] = x
    end
    y = 0
    for x in 0..255
      y = (y + @s[x] + key[x % keylen]) % 256
      @s[x], @s[y] = @s[y], @s[x]
    end
  end

  def self.summary
    "8-bit RC4 PRGA"
  end

  def self.description
    desc = <<-DESC_END
    This generates an 8-bit pseudo-random sequence using RC4. This uses a 40-bit key of '12345'. Definitely not 
    cryptographically secure.
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
