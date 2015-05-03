#!/usr/bin/env ruby
# encoding: ASCII-8BIT

# This is the base class from which all Entrospection generators are derived.
# Each generator subclass must define one method, .next_chunk(), which should
# return the next chunk of deterministic random data as an ASCII-8BIT encoded
# String with length > 0. After this method is defined, the resulting objects
# will weakly mimic a read-only IO object, supporting read(), readpartial(),
# readchar(), readbyte(), each(), each_char(), and each_byte().

class Generator
  LIBDIR = File.absolute_path(File.dirname(__FILE__))

  def initialize(limit = Float::INFINITY)
    @bytes_remaining = limit
    @buff = ''
  end
  attr_reader :bytes_remaining

  # Alternate constructor that reads the byte limit (if present) from ARGV.
  # Writes output to dst, or returns the generator if dst == nil
  def self.run(dst = $stdout)
    Signal.trap("INT") { exit(0) }
    limit = Float::INFINITY
    if ARGV.last.to_i != 0
      unit = { 'k' => 1024, 'm' => 2**20, 'g' => 2**30 }[ARGV.last[-1].downcase]
      limit = ARGV.last.to_i * (unit || 1)
    else
      raise "Invalid command line arguments" unless ARGV.empty?
    end
    generator = self.new(limit)
    generator.pipe_to(dst) if dst
    generator
  end

  def self.summary
    "No summary has been provided for #{self.class}"
  end

  def self.description
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
    readchar.ord
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

  # List all subclasses (effectively list all generators)
  def self.descendants
    kids = ObjectSpace.each_object(Class).select do |klass|
      klass < self and klass != IOGenerator
    end
  end

  def self.load_all
    @@gmap = {}

    # Load our generator classes
    gen = Dir.glob(File.join(LIBDIR, 'generators', '*.rb'))
    gen.each { |g| require g }

    # Build a map of string-name to class
    descendants.each do |k|
      name = k.to_s.sub('Generator', '')
      @@gmap[name.downcase] = k
    end
  end

  # Return a text description array of all canned generator summaries
  def self.summaries
    @@gmap.map do |name,klass|
      "#{name}#{' ' * (14 - name.length)}- #{klass.summary}"
    end
  end

  def self.gmap
    @@gmap
  end

end

# This class takes an IO object and mimics a Generator, which in turn mimics
# an IO object (only with an enforced read limit).
class IOGenerator < Generator

  def initialize(io, limit = Float::INFINITY)
    super(limit)
    @src_o = io
  end

  def next_chunk
    @src_o.readpartial(64)
  end

end
