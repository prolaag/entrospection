#!/usr/bin/env ruby

# This test shows that our statistical analysis of entropy can detect something
# like a counter (which clearly has an even distribution of bits and bytes)
# interleaved into the stream of random bytes.

# This case demonstrates the utility of the "runs" test.

lcg = 0
i = 0
skip = 0
(2**20).times do
  skip = (i + skip) % 17 + 1
  lcg = (lcg * 6364136223846793005 + 1442695040888963407) % 2**64
  i += skip
  print((i % 256).chr)
  print([lcg].pack('L>'))
end
