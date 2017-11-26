# lib/intake.rb

class Intake
  def initialize(app)
    @app = app

    @inputs = {}
    @intake_filters = {
      'assert' => {
        'path' => [],
      },
      'negate' => {
        'header' => [
          'SERVER_SOFTWARE','SERVER_PROTOCOL','REQUEST_URI',
          'GATEWAY_INTERFACE','SERVER_NAME','SERVER_PORT',
          'SCRIPT_NAME','REQUEST_METHOD','REQUEST_PATH',
          'PATH_INFO','QUERY_STRING','rack.multithread',
          'rack.multiprocess','rack.run_once','rack.input',
          'rack.version','rack.errors','rack.url_scheme',
          'async.callback','async.close','HTTP_COOKIE'
        ]
      }
    }
  end

  def intake
    # take all application parameters into a hash.
    inputs['verb'] = request.request_method
    inputs['path'] = @intake_filters['assert']['path'].keys.zip( request.path_info.split('/').reject { |e| e.empty? } ).to_h
    inputs['body'] = {}; request.body.gets.split('&').each { |e| Hash[*e.split('=')].each { |k,v| inputs['body'][k] = v } }
    inputs['query'] = {}; request.query_string.split('&').each { |e| Hash[*e.split('=')].each { |k,v| inputs['query'][k] = v } }
    inputs['header'] = {}; @request.each_header { |k,v| inputs['header'][k] = v unless @intake_filters['negate']['header'].include? k }
    inputs['cookie'] = @request.cookies

    inputs
  end

  def call(env)
    @request = Rack::Request.new(env)

    rules = {}; rules['path'] = {'encodings' => ['json','bson','xml'],'response_type' => ['data','bool']}

    intake_filters['assert']['path'] = rules['path']
    env['intake'] = intake

    @app.call(env)
  end

  attr_reader :request, :config, :inputs, :intake_filters

end
