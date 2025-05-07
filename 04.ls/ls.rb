#!/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'

def split_file_names_by_columns(col_num)
  file_names = Dir.glob('*').sort { |a, b| a.delete('.') <=> b.delete('.') }
  row_num = (file_names.size / col_num.to_f).ceil
  Array.new(col_num) { file_names.slice!(0, row_num) }
end

def display_file(splited_file_names, col_num)
  max_chara_numbers = splited_file_names.map { |a| a.map(&:size).max }
  splited_file_names[0].size.times do |row|
    col_num.times do |col|
      print splited_file_names[col][row] ? "#{splited_file_names[col][row].ljust(max_chara_numbers[col])}  " : ''
    end
    puts
  end
end

opt = OptionParser.new
opt.parse(ARGV)

COLUMN_NUMBER = 3
splited_file_names = split_file_names_by_columns(COLUMN_NUMBER)
display_file(splited_file_names, COLUMN_NUMBER)
