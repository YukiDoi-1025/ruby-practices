class Mode
  FILE_AUTHORITY = { '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx', '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx' }
  FILE_TYPE = { '01' => 'p', '02' => 'c', '04' => 'd', '06' => 'b', '10' => '-', '12' => 'l', '14' => 's' }

  private_constant :FILE_AUTHORITY, :FILE_TYPE

  attr_reader :type, :permission

  def initialize(octal_number)
    file_modes = [octal_number[0, 2]] + octal_number[2..].chars
    @type = FILE_TYPE[file_modes[0]]
    permissions = [FILE_AUTHORITY[file_modes[2]], FILE_AUTHORITY[file_modes[3]], FILE_AUTHORITY[file_modes[4]]]
    @permission = add_special_permission(permissions, file_modes[1]).join
  end

  private

  def add_special_permission(permissions, special_authority_type)
    case special_authority_type
    when '1'
      permissions[2][-1] = permissions[2][-1] == 'x' ? 't' : 'T'
    when '2'
      permissions[1][-1] = permissions[1][-1] == 'x' ? 's' : 'S'
    when '4'
      permissions[0][-1] = permissions[0][-1] == 'x' ? 's' : 'S'
    end
    permissions
  end

end