#!/usr/bin/env ruby
# ldif2txt.rb
#
# Converts an LDIF file to a plain text file
# by concatenating continuation lines.
# 
# Copyright (c) 2018 Daniel Kraus
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
require 'optparse'

options = {}
optparse = OptionParser.new do |opts|
  opts.banner = 'Usage: ldif2txt.rb <ldif_file> [other_ldif_file [yet_another_file [...]]'
  opts.on '-p', '--prefix', 'Prefix lines with current file name.' do
    options[:prefix] = true
  end
  opts.on '-h', '--help', 'Display this help' do
    puts opts
    exit
  end
end
optparse.parse!

if ARGV.length == 0
  puts 'This script needs at least one ldif_file argument.'
  exit 1
end

if options[:prefix]
  prefix_delimiter = ' >>> '
  max_prefix_length = 1 + ARGV.inject(0) do |length, file_name|
    file_name.length > length ? file_name.length : length
  end
end

def print_delimiter(file_name, options)
  if ARGV.length > 1 && !options[:prefix]
    puts "# " + "-" * 70
    puts "# File: #{file_name}"
    puts "# " + "-" * 70
  end
end

ARGV.each do |file_name|
  print_delimiter file_name, options
  text = ''
  if options[:prefix]
    prefix_length = max_prefix_length - file_name.length
  end
  File.readlines(file_name, mode: 'r').each do |line|
    line.chomp!
    if line[0] == ' '
      text += line[1..-1]
    else
      text += "\n"
      if options[:prefix]
        text += file_name + prefix_delimiter.ljust(prefix_length)
      end
      text += line
    end
  end
  puts text.lstrip
end
