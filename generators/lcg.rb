#!/usr/bin/env ruby

# This test shows that LCG (Linear congruential generator) pseudo-random number
# generation produces output that can be detected as non-random by the inline
# statistical tests.

# This case demonstrates the utility of the "q-independence" test.

require_relative 'generator.rb'

i = 0
loop do
  i = (i * 6364136223846793005 + 1442695040888963407) % 2**64
  gprint([i].pack('Q>'))
end

