#!/usr/bin/env ruby

# This generates a pseudo-random sequence by MD5-hashing an integer counter.

require 'digest/md5'

Signal.trap("INT") { exit(0) }

limit = ARGV.first.to_i
bytes_max = limit ? limit : 0
bytes = 0

i = 0
loop do
  data = Digest::MD5.digest([i].pack('Q>')) rescue break
  print data
  bytes += data.length
  break if bytes > bytes_max
  i += 1
end
