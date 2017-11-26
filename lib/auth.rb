# auth.rb

class Auth
  def initialize
  end

  def call(env)
    username = env['intake']['body']['username']
    password = env['intake']['body']['password']
    res = db_authenticate(username,password)
    type = env['intake']['path']['response_type']
    case type
      when 'bool'
        res ? [302, {}, $success] : [200, {}, $failure]
      when 'data'
        success = $success.clone
        success[:data] = res
        res ? [302, {}, success] : [200, {}, $failure]
      when 'nginx'
        if res
          [200, {
            'Auth-Status' => 'OK',
            'Auth-Server' => 'mail.local',
            'Auth-Port' => '25',
          }, $success]
        else
          [200, {
            'Auth-Status' => 'Authentication failed',
            'Auth-Wait' => '3',
          }, $failure]
        end
      else
        [404, {}, $error]
    end
  end

  private

  def db_authenticate(username,password)
    db_creds = {
      host: 'n.n.n.n',
      user: 'central_auth__db_admin_user',
      pass: 'central_auth__password',
      name: 'central_auth'
    }

    query = "SELECT users.id AS uid, users.username AS user, roles.name AS role FROM roles INNER JOIN users ON (users.roles_id = roles.id) WHERE (users.username = '#{username}') AND (users.password_hash = PASSWORD('#{password}')) LIMIT 1"
    connection = Mysql.new(db_creds[:host],db_creds[:user],db_creds[:pass],db_creds[:name])
    result = connection.query(query)
    connection.close
    return false if result.num_rows == 0
    keys = [:uid,:user,:authorization]
    result.each do |row|
      return keys.zip(row).to_h
    end
  end
end
