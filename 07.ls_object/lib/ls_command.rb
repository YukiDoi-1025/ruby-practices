# frozen_string_literal: true

require_relative 'file_attribute'

class LsCommand
  def initialize(option, column_number)
    @option = option
    @file_names = @option.key?(:a) ? Dir.entries('.').sort : Dir.glob('*')
    @file_names.reverse! if @option.key?(:r)
    @file_attributes = @file_names.map { |file_name| FileAttribute.new(file_name) }
    @column_number = column_number
    @total_block = @file_attributes.map(&:block_num).sum
  end

  def display_files
    if @option.key?(:l)
      muximum_hard_link_digit = @file_attributes.map { |file_attribute| file_attribute.hard_link.to_s.length }.max
      muximum_file_size_digit = @file_attributes.map { |file_attribute| file_attribute.file_size.to_s.length }.max
      puts "total #{@total_block}"
      @file_attributes.each do |file_attribute|
        puts file_attribute.output_file_infomation(muximum_hard_link_digit, muximum_file_size_digit).join(' ')
      end
    else
      display_files_split(split_file_names_by_columns)
    end
  end

  private

  def split_file_names_by_columns
    row_num = (@file_names.size / @column_number.to_f).ceil
    Array.new(@column_number) { @file_names.slice!(0, row_num) }
  end

  def display_files_split(split_file_names)
    max_filename_sizes = split_file_names.map { |a| a.map(&:size).max }
    split_file_names[0].size.times do |row|
      split_file_names.size.times do |col|
        file_name = split_file_names[col][row]
        print file_name ? "#{file_name.ljust(max_filename_sizes[col])}  " : ''
      end
      puts
    end
  end
end
