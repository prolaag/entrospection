#!/usr/bin/env ruby

# This test shows that LCG (Linear congruential generator) pseudo-random number
# generation produces output that can be detected as non-random by the inline
# statistical tests.

# This case demonstrates the utility of the "q-independence" test.

i = 0
(2**17).times do
  i = (i * 6364136223846793005 + 1442695040888963407) % 2**64
  print([i].pack('L>'))
end

