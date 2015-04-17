#!/usr/bin/env ruby

# This generates a pseudo-random sequence by using the deterministic pseudo-
# random number generator built into Ruby

require_relative '../generator.rb'

class RubyGenerator < Generator
  def initialize(*args)
    super(*args)
    @r = Random.new(5)  # chosen by fair dice roll
  end

  def summary
    "A ruby pseudo random stream"
  end

  def description
    desc = <<-DESC_END
      This generator uses Ruby's built-in PRNG with a deterministic seed to
      produce data.
    DESC_END
    desc.gsub(/\s+/, " ").strip
  end


  def next_chunk
    [ @r.rand(2**32) ].pack('L>')
  end

end

RubyGenerator.run if __FILE__ == $0

