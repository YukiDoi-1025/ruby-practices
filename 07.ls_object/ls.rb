#!/usr/bin/env ruby

# frozen_string_literal: true

require 'optparse'

def listup_file(col_num)
  all_list = Dir.glob('*').sort
  tmp_list = []
  # 各列の行数を計算
  array_sizes = Array.new(col_num) { all_list.size / col_num }
  (all_list.size % col_num).times { |num| array_sizes[num] += 1 }

  array_sizes.each do |num|
    tmp_list << all_list.slice!(0, num)
  end
  tmp_list
end

def display_file(file_list, col_num)
  max_size = file_list.flatten.map(&:size).max
  row_num = file_list[0].size
  catch :done do
    row_num.times do |row|
      col_num.times do |col|
        if row + 1 > file_list[col].size
          puts
          throw :done
        end
        print "#{file_list[col][row].ljust(max_size)} "
      end
      puts
    end
  end
end

opt = OptionParser.new
opt.parse(ARGV)

col_num = 3
file_list = listup_file(col_num)
display_file(file_list, col_num)
