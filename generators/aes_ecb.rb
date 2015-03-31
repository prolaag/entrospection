#!/usr/bin/env ruby

# This test generates a pseudo-random sequence by encrypting a simple counter
# with AES in ECB mode.

require 'openssl'

def ecb(key, text)
  (aes = OpenSSL::Cipher::Cipher.new('aes-256-ecb').send(:encrypt)).key = key
  aes.update(text) << aes.final
end

Signal.trap("INT") { exit(0) }

key = "\0" * 32
i = 0
loop do
  print ecb(key, [i].pack('Q>')) rescue break
  i += 1
end
