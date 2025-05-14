#!/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'

COLUMN_NUMBER = 3

def split_file_names_by_columns(col_num, show_reverse_order)
  file_names = show_reverse_order ? Dir.glob('*').sort.reverse : Dir.glob('*').sort
  row_num = (file_names.size / col_num.to_f).ceil
  Array.new(col_num) { file_names.slice!(0, row_num) }
end

def display_file(split_file_names)
  max_filename_sizes = split_file_names.map { |a| a.map(&:size).max }
  split_file_names[0].size.times do |row|
    split_file_names.size.times do |col|
      file_name = split_file_names[col][row]
      print file_name ? "#{file_name.ljust(max_filename_sizes[col])}  " : ''
    end
    puts
  end
end

opt = OptionParser.new

params = {}

opt.on('-r [VAL]') { |v| v }
opt.parse!(ARGV, into: params)

split_file_names = split_file_names_by_columns(COLUMN_NUMBER, params.key?(:r))
display_file(split_file_names)
