# lib/encode.rb

class Encode
  def initialize(app)
    @app = app
  end

  def call(env)
    # reject invalid encodings, default to json
    return [404, {'Content-Type' => 'application/json'}, $error.to_json] unless env['intake']['path']['encodings'] == 'json'

    # call down
    status, headers, response = @app.call(env)

    # encode
    enc = env['intake']['path']['encodings']
    encoded = do_encode(enc, response)

    # set content-type header
    headers['Content-Type'] = "application/#{enc}"

    # return
    [status, headers, encoded]
  end

  attr_reader :request

  private

  def do_encode(encoding, text)
    case encoding
      when 'json' then text.to_json
    end
  end

  def do_decode(encoding, code)
    case encoding
      when 'json' then JSON.parse(code)
    end
  end
end
