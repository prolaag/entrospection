#!/usr/bin/env ruby

# This generates a pseudo-random sequence by MD5-hashing an integer counter.

require 'digest/md5'

Signal.trap("INT") { exit(0) }

i = 0
loop do
  print Digest::MD5.digest([i].pack('Q>')) rescue break
  i += 1
end
