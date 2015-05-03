#!/usr/bin/env ruby

# This generator simply loops through all byte values, 0 - 255, in order.
# It's used as a basic sanity check against whiteners - they shouldn't whiten
# this data.

require_relative '../generator.rb'

class IncrementGenerator < Generator

  def initialize(*args)
    super(*args)
    @bytes = (0..255).collect { |x| x.chr }.join
  end

  def self.summary
    "Simple incrementing counter"
  end

  def self.description
    desc = <<-DESC_END
    This generator merely outputs all byte values in order over and over.
    DESC_END
    desc.gsub(/\s+/, " ").strip
  end

  def next_chunk
    @bytes.dup
  end

end

IncrementGenerator.run if __FILE__ == $0

