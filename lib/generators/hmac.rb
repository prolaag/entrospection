#!/usr/bin/env ruby

# This generates a pseudo-random sequence by using OpenSSL's keyed-hash message authentication code (HMAC) along with a randomly generated key

require_relative '../generator.rb'
require 'openssl'

class HmacGenerator < Generator
  
  def hmac(key, data)
    digest = OpenSSL::Digest.new('sha1')
    hmac = OpenSSL::HMAC.digest(digest, key, data)
  end

  def initialize(*args)
    super(*args)
    @key = (0...32).map { (48 + rand(43)).chr }.join
    @i = 1
  end

  def self.summary
    "OpenSSL HMAC hash of an integer counter and random key"
  end

  def self.description
    desc = <<-DESC_END
      This generates a pseudo-random sequence by using HMAC to hash an integer counter with a randomly generated key.
    DESC_END
    desc.gsub(/\s+/, " ").strip
  end

  def next_chunk
    @i += 1
    hmac(@key, [@i].pack('Q>'))
  end

end

HmacGenerator.run if __FILE__ == $0
