#!/usr/bin/env ruby

# This test generates a pseudo-random sequence by encrypting a simple counter
# with AES in ECB mode.

require 'openssl'

def ecb(key, text)
  (aes = OpenSSL::Cipher::Cipher.new('aes-256-ecb').send(:encrypt)).key = key
  aes.update(text) << aes.final
end

limit = ARGV.first.to_i
bytes_max = limit ? limit : 0
bytes = 0
Signal.trap("INT") { exit(0) }

key = "\0" * 32
i = 0
loop do
  data = ecb(key, [i].pack('Q>')) rescue break
  print data
  bytes += data.length
  i += 1
  break if bytes > bytes_max
end
