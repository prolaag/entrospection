#!/usr/bin/env ruby

# This generates a pseudo-random sequence by Murmur2-hashing an integer counter.
# This hash is not designed to be cryptographically secure, but it does produce
# fairly uniform output, though the output of the "runs" test dips briefly
# into dangerous territory.

require_relative '../generator.rb'

class Murmur2Generator < Generator

  def initialize(*args)
    super(*args)
    @i = 0
  end

  def summary
    "A pseudo-random sequence by Murmur2-hashing an integer counter"
  end

  def description
    desc = <<-DESC_END
    This generates a pseudo-random sequence by Murmur2-hashing an integer counter.
    This hash is not designed to be cryptographically secure, but it does produce 
    fairly uniform output, though the output of the "runs" test dips briefly into 
    dangerous territory.
    DESC_END
    desc.gsub(/\s+/, " ").strip
  end

  # Code shamelessly adapted from:
  # http://toblog.bryans.org/2010/12/14/pure-ruby-version-of-murmurhash-2-0
  def murmur_hash2(txt)
    seed = 0
    m = 0x5bd1e995
    r = 24
    len = txt.length

    h = (seed ^ len)
    pos = 0

    while len >= 4
      k = txt[pos, 4].unpack('L<').first
      k = ( k * m ) % 0x100000000
      k ^= k >> r
      k = ( k * m ) % 0x100000000
      h = ( h * m ) % 0x100000000
      h ^= k
      pos += 4
      len -= 4
    end

    if len == 3
      h ^= txt[-1].ord << 16
      h ^= txt[-2].ord << 8
      h ^= txt[-3].ord
    elsif len == 2
      h ^= txt[-1].ord << 8
      h ^= txt[-2].ord
    elsif len == 1
      h ^= txt[-1].ord
    end

    h = ( h * m ) % 0x100000000
    h ^= h >> 13
    h = ( h * m ) % 0x100000000
    h ^= h >> 15

    return h
  end

  def next_chunk
    @i += 1
    [ murmur_hash2([@i].pack('Q>')) ].pack('L>')
  end

end

Murmur2Generator.run if __FILE__ == $0
