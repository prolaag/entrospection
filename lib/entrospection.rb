#!/usr/bin/env ruby
# encoding: ASCII-8BIT

require 'chunky_png'

class Entrospection

  PROJ_ROOT = File.expand_path('../..', __FILE__)
  GENERATOR_DIR = File.expand_path('lib/generators', PROJ_ROOT)

  def initialize()
    @set_bit_lookup = (0..255).collect { |i| i.to_s(2).count('1') }
    @contrast = 0.5
    @grid = Array.new(256) { Array.new(256, 0) }

    # Streaming analysis
    @prev_byte = nil
    @bytes = 0
    @set_bits = 0
    @q_set_bits = 0
    @qbuf = [ 0 ] * 8
    @unqbuf = [ 0 ] * 8
    @ddec = 0
    @dinc = 0
    @byte_count = [ 0 ] * 256

    # Interpreted results
    @pvalue = Hash.new { |h,k| h[k] = Array.new }
    @pvalue_interval = 128
  end
  attr_reader :grid, :bytes, :set_bits, :pvalue, :byte_count
  attr_accessor :contrast

  # Stream bytes in for analysis. Provide any object that responds to
  # .each_byte()
  def <<(src)
    unless @prev_byte
      if src.respond_to?(:read)
        @prev_byte = src.read(1).ord
      elsif src.class <= String
        @prev_byte = src[0].ord
        src = src[1..-1]
      else
        @prev_byte = src.to_i % 256
        return nil
      end
      @bytes = 1
      @byte_count[@prev_byte] += 1
      @set_bits += @set_bit_lookup[@prev_byte]
    end

    # Process each byte
    src.each_byte do |c|
      @byte_count[c] += 1
      @set_bits += @set_bit_lookup[c]
      @bytes += 1
      @grid[@prev_byte][c] += 1
      @prev_byte = c

      # Runs and Q-independence tests
      @q_set_bits += @set_bit_lookup[@qbuf.shift ^ c]
      @qbuf.push c
      if @bytes % 8 == 0
        if (@qbuf[0] << 24) + (@qbuf[1] << 16) + (@qbuf[2] << 8) + @qbuf[3] >
           (@qbuf[4] << 24) + (@qbuf[5] << 16) + (@qbuf[6] << 8) + @qbuf[7]
          @ddec += 1
        else
          @dinc += 1
        end

        # Periodically compute our p-values
        if @bytes % @pvalue_interval == 0
          hist = @byte_count.sort
          e0 = (hist[0] * hist[255])**0.5
          e1 = (hist[1] * hist[254])**0.5

          @pvalue[:binomial] << bpv(@set_bits, @bytes * 8)
          @pvalue[:runs] << bpv(@ddec, @ddec + @dinc)
          @pvalue[:qindependence] << bpv(@q_set_bits, @bytes * 8)
          @pvalue[:gauss_sum] << bpv(e0, e0 + e1)

          # If we have at least 2^10 entries, throw every other one away and
          # double our sampling interval.
          if @pvalue[:binomial].length == 1024
            @pvalue.keys.each do |ptype|
              512.times { |i| @pvalue[ptype].delete_at i }
            end
            @pvalue_interval *= 2
          end
        end
      end
    end
  end

  # Stream bytes *out* of the beginning of the buffer, so we can create a
  # "rolling window" effect.
  def >>(src)
    sub_bytes = 0
    unless @prev_unbyte
      if src.respond_to?(:read)
        @prev_unbyte = src.read(1).ord
      elsif src.class <= String
        @prev_unbyte = src[0].ord
        src = src[1..-1]
      else
        @prev_unbyte = src.to_i % 256
        return nil
      end
      sub_bytes = 1
      @byte_count[@prev_unbyte] -= 1
      @set_bits -= @set_bit_lookup[@prev_unbyte]
    end

    # Now process each un-byte
    src.each_byte do |c|
      @byte_count[c] -= 1
      @set_bits -= @set_bit_lookup[c]
      sub_bytes += 1
      @grid[@prev_unbyte][c] -= 1
      @prev_unbyte = c
      @q_set_bits -= @set_bit_lookup[@unqbuf.shift ^ c]
      @unqbuf.push c
    end

    # For the p-value tests, just delete the first periodic test values
    # corresponding to the fraction of bytes we're subtracting. For example,
    # if we're subtracting 2,000 out of 8,000 gathered bytes, delete the first
    # 25% of results from our arrays.
    @pvalue.each do |_,a|
      frac = a.length * sub_bytes / @bytes
      a[0...frac] = []
    end
    @bytes -= sub_bytes
  end

  # Helper method to compute the probability that a truly random, unbiased
  # sequence would produce a ratio of set bits to total bits more extreme
  # than those provided.
  def bpv(set, total)
    return 0.5 if total == 0
    cf = Math.erfc(2**(-0.5) * (total / 2.0 - set) / (total / 4.0)**(0.5)) / 2
    [ cf, 1.0 - cf ].min * 2   # probability on either extreme
  end

  # Minimum and maximum grid values
  def grid_min
    @grid.collect { |col| col.min }.min
  end
  def grid_max
    @grid.collect { |col| col.max }.max
  end

  # Return a ChunkyPNG image describing all observed adjacent byte correlations
  def covariance_png
    png = ChunkyPNG::Image.new(256, 256)
    f = 0

    # Color auto-scaling
    adj = grid_min * @contrast
    scale = 255.5 / (grid_max - adj)

    256.times do |y|
      256.times do |x|
        color = (scale * (@grid[x][y] - adj)).to_i
        png[x, y] = ChunkyPNG::Color.rgba(color, color, color, 0xFF)
      end
    end
    png
  end

  # Return a 256-element array of normalized byte frequencies. The most frequent
  # byte will be represented by 1.0, and all other bytes as a fraction thereof.
  def byte_histogram
    freq = @grid.collect { |c| c.inject(:+) }
    max = freq.max
    freq.collect { |x| x.to_f / max }
  end

  # Return an 8-element array of normalized bit frequencies, from least
  # significant bit to most significant.
  def bit_histogram
    freq = Array.new(8, 0)
    @byte_count.each_with_index do |count, i|
      8.times do |p|
        freq[p] += (i & 1) * count
        i >>= 1
      end
    end
    freq.collect { |x| x.to_f / @bytes }
  end

  # Return a ChunkyPNG image describing the frequency of each byte value
  def byte_png
    png = ChunkyPNG::Image.new(256, 256)
    his = byte_histogram()
    avg = his.inject(:+) / 256
    scale = 4096 * @contrast
    256.times do |y|
      256.times do |x|
        freq = his[(y / 16) * 16 + (x / 16)]
        adj = [ ((freq - avg).abs * scale).to_i, 85 ].min
        if freq > avg
          red = 170 - adj * 2
          blue = 170 + adj
        else
          red = 170 + adj
          blue = 170 - adj * 2
        end
        png[x, y] = ChunkyPNG::Color.rgba(red, [ red, blue ].min, blue, 0xFF)
      end
    end
    png
  end

  # Return a ChunkyPNG image describing the distribution of each bit
  def bit_png
    png = ChunkyPNG::Image.new(256, 256, ChunkyPNG::Color::WHITE)
    256.times { |x| png[x, 128] = ChunkyPNG::Color.rgba(99, 99, 99, 0xFF) }
    bit_histogram.each_with_index do |freq, i|
      # This scales from 48.0% to 52.0%
      h = 2**(Math.log((freq - 0.5).abs, 10) + 8.7) + 1
      h = [ h.to_i, 127 ].min
      h.times do |y|
        color = ChunkyPNG::Color.rgba(y * 2, [ 180 - y * 2, 0 ].max, 0, 0xFF)
        y = 0 - y if freq > 0.5
        20.times { |x| png[i * 32 + 6 + x, 128 + y] = color }
      end
    end
    png
  end

  # Return a ChunkyPNG image graphing the only the provided pvalue over time
  def pvalue_png(dist = :binomial)
    png = ChunkyPNG::Image.new(256, 256, ChunkyPNG::Color::WHITE)
    256.times do |x|
      pos = @pvalue[dist][x * @pvalue[dist].length / 256]
      y = Math.log(pos * 1000000) * 25 - 90
      [ y, 3 ].max.to_i.times do |h|
        png[x, 255 - h] = ChunkyPNG::Color.rgba(255 - h, h, 0, 0xFF)
      end
    end
    png
  end

  # Return a ChunkyPNG image graphing the four included pvalue results over time
  def pvalues_png
    png = ChunkyPNG::Image.new(256, 256, ChunkyPNG::Color::WHITE)
    [ :binomial, :qindependence, :gauss_sum, :runs ].each_with_index do |t, i|
      256.times do |x|
        pos = @pvalue[t][x * @pvalue[t].length / 256]
        y = Math.log(pos * 1000000) * 6.0 - 22
        [ y, 3 ].max.to_i.times do |h|
          scale = [y, 3].max.to_i + h * 3
          color = ChunkyPNG::Color.rgba(255 - scale, scale, 0, 0xFF)
          png[x, 255 - h - 64 * i] = color
        end
      end
    end
    png
  end

end
