#!/usr/bin/env ruby

# This generates a pseudo-random sequence by using OpenSSL's keyed-hash message authentication code (HMAC)

require_relative '../generator.rb'
require 'openssl'

class HmacGenerator < Generator
  
  def hmac(key, data)
    digest = OpenSSL::Digest.new('sha1')
    hmac = OpenSSL::HMAC.digest(digest, key, data)
  end

  def initialize(*args)
    super(*args)
    @key = (0...32).map{ |i| i.to_s 32}.join
    @i = 1
  end

  def self.summary
    "OpenSSL HMAC hash of an integer counter"
  end

  def self.description
    desc = <<-DESC_END
      This generates a pseudo-random sequence by using HMAC to hash an integer counter.
    DESC_END
    desc.gsub(/\s+/, " ").strip
  end

  def next_chunk
    @i += 1
    hmac(@key, [@i].pack('Q>'))
  end

end

HmacGenerator.run if __FILE__ == $0
