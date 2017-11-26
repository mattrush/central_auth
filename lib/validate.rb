# lib/validate.rb

class Validate
  def initialize(app, message = 'added by the validation filter.', &config)
    @app = app
    @message = message
    @config = config

    @rules = {
      'verb' => [],
      'path' => {},
      'body' => {},
      'query' => {},
      'header' => {},
      'cookie' => {}
    }
    @rule_validators = {
      'verb' =>   [[nil],      ['refuse'],         ['white']],
      'path' =>   [['refuse'], ['refuse'],         ['white','regexp']],
      'body' =>   [['drop'],   ['refuse','blank'], ['white','regexp']],
      'query' =>  [['drop'],   ['refuse','blank'], ['white','regexp']],
      'header' => [['drop'],   ['refuse','blank'], ['white','regexp']],
      'cookie' => [['drop'],   ['refuse','blank'], ['white','regexp']]
    }
  end

  def refuse(param_type, key=nil, value)
    rule('refuse', param_type, key, value)
  end

  def drop(param_type, key=nil, value)
    rule('drop', param_type, key, value)
  end

  def blank(param_type, key=nil, value)
    rule('blank', param_type, key, value)
  end

  def call(env)
    @request = Rack::Request.new(env)

    instance_eval(&config)

    #handler = @rules
    #status, headers, response = @app.call(env)
    #[status, headers, [@message, response]]
  end

  attr_accessor :request, :config, :rules, :rule_validators

  private

  def rule(action, param_type, key=nil, value)
    #TODO replace this case with a ternary statement ?
    case key.nil?
      when true then @rules[param_type] = { 'action' => action, 'value' => value }
      else @rules[param_type][key] = { 'action' => action, 'value' => value }
    end
  end
end
