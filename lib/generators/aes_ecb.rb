#!/usr/bin/env ruby

# This test generates a pseudo-random sequence by encrypting a simple counter
# with AES in ECB mode.

require_relative '../generator.rb'
require 'openssl'

class AesEcbGenerator < Generator

  def ecb(key, text)
    (aes = OpenSSL::Cipher::Cipher.new('aes-256-ecb').send(:encrypt)).key = key
    aes.update(text) << aes.final
  end

  def initialize(*args)
    super(*args)
    @key = "\0" * 32
    @i = 0
  end

  def summary
    "A Pseudo-random sequence by encrypting a counter with AES in ECB mode."
  end

  def description
    desc = <<-DESC_END
    This generatior produces a pseudo-random sequence by encrypting a simple counter
    with AES in ECB mode."
    DESC_END
    desc.gsub(/\s+/, " ").strip
  end


  def next_chunk
    @i += 1
    ecb(@key, [@i].pack('Q>'))
  end

end

AesEcbGenerator.run if __FILE__ == $0
