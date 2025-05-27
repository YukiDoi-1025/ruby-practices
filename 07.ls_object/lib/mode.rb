# frozen_string_literal: true

class Mode
  FILE_AUTHORITY = { '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx', '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx' }.freeze
  FILE_TYPE = { '01' => 'p', '02' => 'c', '04' => 'd', '06' => 'b', '10' => '-', '12' => 'l', '14' => 's' }.freeze
  FILE_SPECIAL_AUTHORITIES = [{ mask: 0b100, type: 's' }, { mask: 0b010, type: 's' }, { mask: 0b001, type: 't' }].freeze

  private_constant :FILE_AUTHORITY, :FILE_TYPE, :FILE_SPECIAL_AUTHORITIES

  attr_reader :type, :permission

  def initialize(octal_number)
    file_modes = [octal_number[0, 2]] + octal_number[2..].chars
    @type = FILE_TYPE[file_modes[0]]
    @permission = add_special_permission(file_modes).join
  end

  private

  def add_special_permission(file_modes)
    file_authorities = Array.new(3) { |i| FILE_AUTHORITY[file_modes[i + 2]].dup }
    special_authority_type = file_modes[1].to_i

    FILE_SPECIAL_AUTHORITIES.each_with_index do |file_special_authority, index|
      if special_authority_type.anybits?(file_special_authority[:mask])
        file_authorities[index][-1] = file_modes[index + 2].to_i.anybits?(0b001) ? file_special_authority[:type] : file_special_authority[:type].upcase
      end
    end
    file_authorities
  end
end
