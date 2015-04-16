#!/usr/bin/env ruby
# encoding: ASCII-8BIT

class Generator

  def initialize(limit = Float::INFINITY)
    @bytes_remaining = limit
    @buff = ''
  end
  attr_reader :bytes_remaining

  # Alternate constructor that reads the byte limit (if present) from ARGV.
  # Writes output to dst, or returns the generator if dst == nil
  def self.run(dst = $stdout)
    limit = Float::INFINITY
    if ARGV[0].to_i != 0
      unit = { 'k' => 1024, 'm' => 2**20, 'g' => 2**30 }[ARGV[0][-1].downcase]
      limit = ARGV[0].to_i * (unit || 1)
    end
    generator = self.new(limit)
    generator.pipe_to(dst) if dst
    generator
  end

  def summary
    "No summary has been provided for #{self.class}"
  end

  def description
    "No description has been provided for #{self.class}"
  end


  ##  Mimic minimal set of IO behaviors  ##

  def read(bytes)
    ret = ''

    # Ensure we don't go past our byte limit
    if bytes > @bytes_remaining
      return nil if @bytes_remaining == 0
      bytes = @bytes_remaining
    end
    @bytes_remaining -= bytes

    # Read whole buffs at a time, then take bytes as needed from the last buff
    while bytes - ret.length > @buff.length
      ret << @buff
      @buff = next_chunk
    end
    ret << @buff.slice!(0, bytes - ret.length)
  end
  alias :readpartial :read

  def readchar
    return nil if @bytes_remaining == 0
    @bytes_remaining -= 1
    @buff = next_chunk if @buff.empty?
    @buff.slice!(0)
  end

  def readbyte
    read(1).ord
  end

  def each
    yield readchar while @bytes_remaining > 0
  end
  alias :each_char :each

  def each_byte
    yield readbyte while @bytes_remaining > 0
  end

  # Write to the given IO object up to the provided byte limit bytes.
  # Return on SIGPIPE or when the byte limit is reached.
  def pipe_to(io)
    begin
      io.print(read(8192)) while @bytes_remaining > 0
    rescue Errno::EPIPE
      return $!
    end
    nil
  end

end
