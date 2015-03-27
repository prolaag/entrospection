#!/usr/bin/env ruby
# encoding: ASCII-8BIT

require 'chunky_png'

class Entrospection

  def initialize(opts = {})
    @width = opts.fetch(:width, 1).to_i
    @height = opts.fetch(:height, 1).to_i
    @contrast = opts.fetch(:contrast, 0.05).to_f.abs
    remaining = (opts.keys - [ :width, :height, :contrast ]).first
    raise ArgumentError, "unrecognized option: #{remaining}" if remaining
    raise ArgumentError, "contrast out of bounds" if @contrast > 1.0
    raise ArgumentError, "height too small" if @height < 1
    raise ArgumentError, "width too small" if @width < 1

    @faces = @width * @height
    @grid = Array.new(@faces) { Array.new(256) { Array.new(256, 0) } }
    @prev_byte = nil
    @face = 0
  end
  attr_reader :width, :height, :contrast, :grid, :faces

  # Stream bytes in for analysis. Provide any object that responds to
  # .each_byte()
  def <<(src)
    unless @prev_byte
      if src.class <= IO
        @prev_byte = src.read(1).ord
      elsif src.class <= String
        @prev_byte = src[0].ord
        bytes = src[1..-1]
      else
        @prev_byte = src.to_i % 256
        return nil
      end
    end

    # Process, rotating through all faces one byte at a time
    src.each_byte do |c|
      @grid[@face][@prev_byte][c] += 1
      @prev_byte = c
      @face = (@face + 1) % @faces
    end
  end

  # Minimum and maximum grid values
  def grid_min
    @grid.collect { |face| face.collect { |col| col.min }.min }.min
  end
  def grid_max
    @grid.collect { |face| face.collect { |col| col.max }.max }.max
  end

  # Return a ChunkyPNG image describing all observed bytes
  def heatmap
    png = ChunkyPNG::Image.new(@width * 256, @height * 256)
    f = 0

    # Color auto-scaling
    adj = grid_min * @contrast
    scale = 255.5 / (grid_max - adj)

    # Render each pixel; faces are interleved
    @width.times do |w|
      @height.times do |h|
        256.times do |row|
          256.times do |col|
            color = (scale * (@grid[f][col][row] - adj)).to_i
            x = col * @width + w
            y = row * @height + h
            png[x, y] = ChunkyPNG::Color.rgba(color, color, color, 0xFF)
          end
        end
        f += 1
      end
    end
    png
  end

end


if $0 == __FILE__
  src = $stdin
  src = File.open(ARGV.first) if ARGV.first
  ent = Entrospection.new(width: 3, height: 2, contrast: 0.8)
  ent << src
  ent.heatmap.save('output.png', :interlace => true)
end
