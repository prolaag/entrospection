#!/usr/bin/env ruby

# This generates a pseudo-random sequence by MD5-hashing an integer counter.

require_relative 'generator.rb'

i = 0
loop do
  gprint Digest::MD5.digest([i].pack('Q>'))
  i += 1
end
