#!/usr/bin/env ruby

# This test shows that the statistical tests easily catch something like
# a particular bit that appears <1% less often than its counterparts.
# The binomial test is particularly sensitive to this case.

require_relative '../generator.rb'
require 'digest/md5'

class PrunedBitGenerator < Generator

  def initialize(*args)
    super(*args)
    @i = 0
    @s = 0
  end

  def self.summary
    "MD5 data with LSB appearing <1% less often"
  end

  def self.description
    desc = <<-DESC_END
      This test shows that the statistical tests easily catch something like
      a particular bit that appears <1% less often than its counterparts.
      The binomial test is particularly sensitive to this case.
    DESC_END
    desc.gsub(/\s+/, " ").strip
  end

  def next_chunk
    @i += 1
    @s = (@s * 6364136223846793005 + 1442695040888963407) % 2**64
    raw = Digest::MD5.digest(@s.to_s)
    #prune LSB randomly. about half the expected effect since some are already zero
    raw = raw.unpack('C*').map { |x| @i % 100 == 0 ? x & 0xFE : x }.pack('C*')
    raw
  end


end

PrunedBitGenerator.run if __FILE__ == $0

