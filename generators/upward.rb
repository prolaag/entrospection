#!/usr/bin/env ruby

# This generates a pseudo-random sequence by MD5-hashing an integer counter,
# but nudges 0.5% of the bytes updwards to produce demonstrable skew.

# This case demonstrates the utility of the "runs" test.

require 'digest/md5'

(2**16).times do |i|
  print Digest::MD5.digest([i].pack('L>'))
  md5 = Digest::MD5.digest([i].pack('L<'))
  msb = md5[0].ord
  md5[0] = ('%08b' % msb).reverse.to_i(2).chr if msb < 43
  print md5
end
