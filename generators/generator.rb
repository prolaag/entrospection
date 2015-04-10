#!/usr/bin/env ruby

# Helper template for pseudo-random number generators, provides:
#  - clean handling of SIGINT/SIGPIPE
#  - command-line limited output

require 'digest/md5'

Signal.trap("INT") { exit(0) }

# Determine the number of output bytes we should constrain ourselves to
$generator_bytelimit ||= 2**64
if ARGV.length == 1 and ARGV.first.to_i > 0
  unit = { 'k' => 1024, 'm' => 2**20, 'g' => 2**30 }[ARGV.first[-1].downcase]
  $generator_bytelimit = ARGV.first.to_i * (unit || 1)
end

def gprint(raw)
  begin
    if raw.length < $generator_bytelimit
      print raw
      $generator_bytelimit -= raw.length
    else
      print raw[0, $generator_bytelimit]
      Kernel.exit(0)
    end
  rescue Errno::EPIPE
    Kernel.exit(0)
  end
end

raise "not a generator" if $0 == __FILE__
