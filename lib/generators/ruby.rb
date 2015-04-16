#!/usr/bin/env ruby

# This generates a pseudo-random sequence by using the deterministic pseudo-
# random number generator built into Ruby

require_relative 'generator.rb'

r = Random.new(5)  # chosen by fair dice roll
loop { gprint [ r.rand(2**32) ].pack('L>') }
