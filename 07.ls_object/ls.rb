#!/usr/bin/env ruby

require 'optparse'
require_relative './lib/ls_command'

COLUMN_NUMBER = 3

opt = OptionParser.new

opt.on('-a [VAL]') { |v| v }
opt.on('-r [VAL]') { |v| v }
opt.on('-l [VAL]') { |v| v }
opt.parse(ARGV)

divided_option = {}
ARGV[0][1..].to_s.chars.each { |char| divided_option[char.to_sym] = true}

p divided_option

ls = LsCommand.new(divided_option, COLUMN_NUMBER)

ls.display_files
