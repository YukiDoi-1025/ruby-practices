#!/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'
require_relative './lib/ls_command'

COLUMN_NUMBER = 3

opt = OptionParser.new

option = {}

opt.on('-a') { |v| v }
opt.on('-r') { |v| v }
opt.on('-l') { |v| v }
opt.parse!(ARGV, into: option)

ls = LsCommand.new(option, COLUMN_NUMBER)

ls.display_files
