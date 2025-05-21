#!/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'
require 'etc'

COLUMN_NUMBER = 3
UNIT_BLOCK_SIZE = 1024
FILE_TYPE = { '01' => 'p', '02' => 'c', '04' => 'd', '06' => 'b', '10' => '-', '12' => 'l', '14' => 's' }.freeze
FILE_AUTHORITY = { '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx', '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx' }.freeze
FILE_SPECIAL_AUTHORITIES = [{ mask: 0b100, type: 's' }, { mask: 0b010, type: 's' }, { mask: 0b001, type: 't' }].freeze

def split_file_names_by_columns(file_names, col_num)
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

def add_special_authority(file_modes)
  file_authorities = Array.new(3) { |i| FILE_AUTHORITY[file_modes[i + 2]].dup }
  special_authority_type = file_modes[1].to_i

  FILE_SPECIAL_AUTHORITIES.each_with_index do |file_special_authority, index|
    if special_authority_type.anybits?(file_special_authority[:mask])
      file_authorities[index][-1] = file_modes[index + 2].to_i.anybits?(0b001) ? file_special_authority[:type] : file_special_authority[:type].upcase
    end
  end
  file_authorities
end

def analyze_file_attributes(file_names)
  total_block = 0
  maximum_file_size_digit = file_names.map { |file_name| File.size(file_name).to_s.length }.max
  maximum_nlink_digit = file_names.map { |file_name| File.lstat(file_name).nlink.to_s.length }.max

  file_attributes = file_names.map do |file_name|
    file_status = File.lstat(file_name)
    file_mode_octal_number = file_status.mode.to_s(8).rjust(6, '0')
    file_modes = [file_mode_octal_number[0, 2]] + file_mode_octal_number[2..].chars
    mtime = file_status.mtime

    total_block += File.symlink?(file_name) ? 0 : (file_status.size / file_status.blksize.to_f).ceil * (file_status.blksize / UNIT_BLOCK_SIZE)
    [
      FILE_TYPE[file_modes[0]] + add_special_authority(file_modes).join,
      file_status.nlink.to_s.rjust(maximum_nlink_digit),
      Etc.getpwuid(file_status.uid).name,
      Etc.getgrgid(file_status.gid).name,
      file_status.size.to_s.rjust(maximum_file_size_digit),
      "#{mtime.strftime('%b ')}#{mtime.day.to_s.rjust(2)} #{mtime.hour.to_s.rjust(2, '0')}:#{mtime.min.to_s.rjust(2, '0')}",
      File.symlink?(file_name) ? "#{file_name} -> #{File.readlink(file_name)}" : file_name
    ]
  end
  [total_block, file_attributes]
end

opt = OptionParser.new

params = {}

opt.on('-a') { |v| v }
opt.on('-r') { |v| v }
opt.on('-l') { |v| v }
opt.parse!(ARGV, into: params)

file_names = params.key?(:a) ? Dir.entries('.').sort : Dir.glob('*')
file_names.reverse! if params.key?(:r)

if params.key?(:l)
  total_block, file_attributes = analyze_file_attributes(file_names)
  puts "total #{total_block}"
  file_attributes.each { |file_attribute| puts file_attribute.join(' ') }
else
  split_file_names = split_file_names_by_columns(file_names, COLUMN_NUMBER)
  display_file(split_file_names)
end
