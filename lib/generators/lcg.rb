#!/usr/bin/env ruby

# This test shows that LCG (Linear congruential generator) pseudo-random number
# generation produces output that can be detected as non-random by the inline
# statistical tests.

# This case demonstrates the utility of the "q-independence" test.

require_relative 'generator.rb'

limit = ARGV.first.to_i
bytes_max = limit ? limit : 0
bytes = 0

limit = ARGV.first.to_i
bytes_max = limit ? limit : 0
bytes = 0

i = 0
loop do
  i = (i * 6364136223846793005 + 1442695040888963407) % 2**64
  data = ([i].pack('Q>')) rescue break
  gprint data
  bytes += data.length
  break if bytes > bytes_max
end

