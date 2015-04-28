#!//usr/bin/env ruby
# encoding: ASCII-8BIT

# Simple test script to ensure the determinism of all generators.

PROJECT_DIR = File.expand_path('../..', __FILE__)
$LOAD_PATH.push(File.join(PROJECT_DIR, 'lib'))

require 'fileutils.rb'
require 'entrospection.rb'
require 'generator.rb'

Generator.load_all
OUT_FILE = '/tmp/entrotest.txt'
BASE_FILE = File.join(File.dirname(__FILE__), 'baseline.txt')

File.open(OUT_FILE, 'w') do |w|
  Generator.gmap.keys.sort.each do |name|
    klass = Generator.gmap[name]
    ent = Entrospection.new()
    w.puts "  -- #{name} --"
    ent << klass.new(2**16)
    ent.pvalue.keys.sort.each do |test|
      results = ent.pvalue[test]
      result = results.inject(:+) / results.length
      w.print "#{name}:#{' ' * 20}"[0, 20]
      w.puts "%02u.%u%%" % [ (result * 100).to_i, (result * 1000).to_i % 10 ]
    end
    w.puts
  end
end

diff = `diff -u #{BASE_FILE} #{OUT_FILE} 2>/dev/null`.strip
diff = File.read(OUT_FILE) unless File.exist?(BASE_FILE)
diff = false if diff.empty?
if ARGV.first == '-b'
  FileUtils.mv OUT_FILE, BASE_FILE
  puts(diff ? 'baseline updated' : 'no change')
else
  File.unlink OUT_FILE
  puts(diff ? 'failed' : 'passed')
  if ARGV.first == '-v'
    puts "\n#{diff}" if diff
  elsif ARGV.length > 0
    raise "Invalid option: #{ARGV.first}"
  end
end
