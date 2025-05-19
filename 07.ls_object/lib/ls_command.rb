require_relative 'file_attribute'

class LsCommand
  def initialize(option, column_number)
    @option = option
    file_names = @option.has_key?(:a) ? Dir.entries('.').sort : Dir.glob('*')
    file_names.reverse! if @option.has_key?(:r)
    @file_attributes = file_names.map { |file_name| FileAttribute.new(file_name) }
    @column_number = column_number
    @total_block = @file_attributes.map(&:block_num).sum
    @muximum_link_digit = Math.log10(@file_attributes.map(&:hard_link).max).floor + 1
    @muximum_file_size_digit = Math.log10(@file_attributes.map(&:file_size).max).floor + 1
  end

  def display_files
    # lオプションの有無での表示切替機能を実装する
    puts "total #{@total_block}"
    @file_attributes.each do |file_attribute|
      puts file_attribute.output_file_infomation(@muximum_link_digit, @muximum_file_size_digit).join(' ')
    end
  end

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
end