#!/usr/bin/env ruby

# This test generates a pseudo-random sequence by encrypting a simple counter
# with AES in ECB mode.

require 'openssl'

def ecb(key, text)
  (aes = OpenSSL::Cipher::Cipher.new('aes-256-ecb').send(:encrypt)).key = key
  aes.update(text) << aes.final
end

key = "\0" * 32
(2**17).times { |i| print ecb(key, [i].pack('L>')) }
