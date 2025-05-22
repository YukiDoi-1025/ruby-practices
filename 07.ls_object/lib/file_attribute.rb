# frozen_string_literal: true

require_relative 'mode'
require 'etc'

class FileAttribute
  UNIT_BLOCK_SIZE = 1024

  attr_reader :name, :mode, :hard_link, :user_name, :group_name, :file_size, :update_time, :block_num

  def initialize(file_name)
    file_status = File.lstat(file_name)
    @name = file_name
    @mode = Mode.new(file_status.mode.to_s(8).rjust(6, '0'))
    @hard_link = file_status.nlink
    @user_name = Etc.getpwuid(file_status.uid).name
    @group_name = Etc.getgrgid(file_status.gid).name
    @file_size = file_status.size
    @update_time = file_status.mtime
    @block_num = File.symlink?(file_name) ? 0 : (file_status.size / file_status.blksize.to_f).ceil * (file_status.blksize / UNIT_BLOCK_SIZE)
  end

  def output_file_infomation(maximum_hard_link_digit, maximum_file_size_digit)
    [
      @mode.type + @mode.permission,
      @hard_link.to_s.rjust(maximum_hard_link_digit),
      @user_name,
      @group_name,
      @file_size.to_s.rjust(maximum_file_size_digit),
      "#{@update_time.strftime('%b ')}#{@update_time.day.to_s.rjust(2)} " \
        "#{@update_time.hour.to_s.rjust(2, '0')}:#{@update_time.min.to_s.rjust(2, '0')}",
      File.symlink?(@name) ? "#{@name} -> #{File.readlink(@name)}" : @name
    ]
  end
end
