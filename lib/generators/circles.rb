#!/usr/bin/env ruby

# This generates a pseudo-random sequence by using the deterministic pseudo-
# random number generator built into Ruby

require_relative '../generator.rb'

class CirclesGenerator < Generator
  def initialize(*args)
    super(*args)
    @r = Random.new(5)  # chosen by fair dice roll
  end

  def self.summary
    'Generate something remotely resembling a circle'
  end

  def self.description
    desc = <<-DESC_END
      Create an output distribution that appears circular
      in the covariance image.
    DESC_END
    desc.gsub(/\s+/, " ").strip
  end


  def next_chunk
    amp = [
      (@r.rand(64) + 1) * 2,
      (@r.rand(64) + 1) * 2,
    ].max
    vals = [
      @r.rand,
      @r.rand,
    ]
    num = [
      Math.cos(vals[0] * 2 * Math::PI) * amp + 128,
      Math.sin(vals[0] * 2 * Math::PI) * amp + 128,
      Math.cos(vals[1] * 2 * Math::PI) * amp + 128,
      Math.sin(vals[1] * 2 * Math::PI) * amp + 128,
    ]

    val = 0
    num.each_with_index do |n, idx|
      val += (n.to_i) << 8 * idx
    end

    [ val ].pack('L>')
  end
end

CirclesGenerator.run if __FILE__ == $0

