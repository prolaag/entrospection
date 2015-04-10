#!/usr/bin/env ruby

# This test shows that our statistical analysis of entropy can detect something
# like a counter (which clearly has an even distribution of bits and bytes)
# interleaved into the stream of random bytes.

# This case demonstrates the utility of the "runs" test.

Signal.trap("INT") { exit(0) }

limit = ARGV.first.to_i
bytes_max = limit ? limit : 0
bytes = 0

lcg = 0
i = 0
skip = 0
loop do
  skip = (i + skip) % 17 + 1
  lcg = (lcg * 6364136223846793005 + 1442695040888963407) % 2**64
  i += skip
  data = ((i % 256).chr + [lcg].pack('Q>')) rescue break
  print data
  bytes += data.length
  break if bytes > bytes_max
end
