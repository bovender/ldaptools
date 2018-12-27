#!/usr/bin/env ruby
# ldif2txt.rb
# Converts an LDIF file to a plain text file
# by concatenating continuation lines.
require 'optparse'

optparse = OptionParser.new do |opts|
  opts.banner = 'Usage: ldif2txt.rb <ldif_file>'
  opts.on '-h', '--help', 'Display this help' do
    puts opts
    exit
  end
end
optparse.parse!

if ARGV.length != 1
  puts 'This script needs exactly one argument.'
  exit 1
end

text = ''
File.readlines(ARGV[0], mode: 'r').each do |line|
  line.chomp!
  if line[0] == ' '
    text += line[1..-1]
  else
    text += "\n"
    text += line
  end
end
puts text
