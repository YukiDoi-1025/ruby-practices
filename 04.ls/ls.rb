#!/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'
require 'etc'

COLUMN_NUMBER = 3
UNIT_BLOCK_SIZE = 1024
FILE_TYPE = { '01' => 'p', '02' => 'c', '04' => 'd', '06' => 'b', '10' => '-', '12' => 'l', '14' => 's' }.freeze
FILE_AUTHORITY = { '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx', '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx' }.freeze

def split_file_names_by_columns(col_num, show_reverse_order)
  file_names = show_reverse_order ? Dir.glob('*').reverse : Dir.glob('*')
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

def add_special_authority(file_authorities, special_authority_type)
  case special_authority_type
  when '1'
    file_authorities[2][-1] = file_authorities[2][-1] == 'x' ? 't' : 'T'
  when '2'
    file_authorities[1][-1] = file_authorities[1][-1] == 'x' ? 's' : 'S'
  when '4'
    file_authorities[0][-1] = file_authorities[0][-1] == 'x' ? 's' : 'S'
  end
  file_authorities
end

def calculate_maximum_file_size(file_names)
  maximum_file_size = 0
  file_names.each do |file_name|
    maximum_file_size = File.size(file_name) if File.size(file_name) > maximum_file_size
  end
  maximum_file_size
end

def analyze_file_attributes(file_names)
  total_block = 0
  maximum_file_size_digit = Math.log10(calculate_maximum_file_size(file_names)).floor + 1

  file_attributes = file_names.map do |file_name|
    file_status = File.stat(file_name)
    file_mode_octal_number = file_status.mode.to_s(8).rjust(6, '0')
    file_modes = [file_mode_octal_number[0, 2]] + file_mode_octal_number[2..].chars
    file_authorities = add_special_authority([FILE_AUTHORITY[file_modes[2]], FILE_AUTHORITY[file_modes[3]], FILE_AUTHORITY[file_modes[4]]], file_modes[1])

    total_block += (file_status.size / file_status.blksize.to_f).ceil * (file_status.blksize / UNIT_BLOCK_SIZE)
    [
      FILE_TYPE[file_modes[0]] + file_authorities.join,
      file_status.nlink,
      Etc.getpwuid(file_status.uid).name,
      Etc.getgrgid(file_status.gid).name,
      file_status.size.to_s.rjust(maximum_file_size_digit),
      "#{file_status.mtime.strftime('%b ')}#{file_status.mtime.day.to_s.rjust(2)} " \
        "#{file_status.mtime.hour.to_s.rjust(2, '0')}:#{file_status.mtime.min.to_s.rjust(2, '0')}",
      file_name
    ]
  end
  [total_block, file_attributes]
end

opt = OptionParser.new

params = {}

opt.on('-l [VAL]') { |v| v }
opt.parse!(ARGV, into: params)

if params.key?(:l)
  file_names = Dir.glob('*')
  total_block, file_attributes = analyze_file_attributes(file_names)
  puts "total #{total_block}"
  file_attributes.each { |file_attribute| puts file_attribute.join(' ') }
else
  split_file_names = split_file_names_by_columns(COLUMN_NUMBER, params.key?(:r))
  display_file(split_file_names)
end
