#!/usr/bin/env ruby

# This test shows that our inline statistical tests easily catch something like
# a particular byte pattern that appears 15% less often than its counterparts.

# This case demonstrates the utility of the "gauss sum" test. You will also
# see a subtle cross appear towards at the top left half of the correlation
# image. The octet 'e' (0b1100101) was chosen because it contains an equal
# number of set and unset bits.

require_relative 'generator.rb'

i = s = 0
loop do
  s = (s * 6364136223846793005 + 1442695040888963407) % 2**64
  raw = Digest::MD5.digest(s.to_s)
  raw.delete!('e') if i % 7 == 0
  gprint(raw)
  i += 1
end

