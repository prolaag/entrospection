#!/usr/bin/env ruby

# This generates a pseudo-random sequence by MD5-hashing an integer counter.

require 'digest/md5'

(2**17).times { |i| print Digest::MD5.digest([i].pack('L>')) }
