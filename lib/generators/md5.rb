#!/usr/bin/env ruby

# This generates a pseudo-random sequence by MD5-hashing an integer counter.

require_relative 'generator.rb'

limit = ARGV.first.to_i
bytes_max = limit ? limit : 0
bytes = 0

i = 0
loop do
  data = Digest::MD5.digest([i].pack('Q>'))
  gprint data
  bytes += data.length
  break if bytes > bytes_max
  i += 1
end
