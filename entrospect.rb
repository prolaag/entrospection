#!/usr/bin/env ruby
# encoding: ASCII-8BIT

require 'chunky_png'

# Tuning parameters
width = 3
height = 2
contrast = 0.85

grid = Array.new(width * height) { Array.new(256) { Array.new(256, 0) } }
f = $stdin
f = File.open(ARGV.first) if ARGV.first
last = f.read(1).ord
face = 0
f.each_byte do |c|
  grid[face][last][c] += 1
  last = c
  face = (face + 1) % grid.length
end

# Color auto-scaling
min = grid.collect { |face| face.collect { |col| col.min }.min }.min
max = grid.collect { |face| face.collect { |col| col.max }.max }.max
raise "No data" unless max > 0
adj = min * contrast
scale = 255.5 / (max - adj)

# Metadata
puts "Max: #{max}"
puts "Min: #{min}"

# Construct our image
png = ChunkyPNG::Image.new(256 * width, 256 * height, ChunkyPNG::Color::BLACK)
face = 0
width.times do |w|
  height.times do |h|
    256.times do |row|
      256.times do |col|
        color = (scale * (grid[face][col][row] - adj)).to_i
        x = col * width + w
        y = row * height + h
        png[x, y] = ChunkyPNG::Color.rgba(color, color, color, 0xFF)
      end
    end
    face += 1
  end
end

png.save('output.png', :interlace => true)

