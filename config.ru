# config.ru

$success = {status: 'success'}
$failure = {status: 'fail'}
$error = {status: 'error'}

require 'time'
require 'mysql'
require 'json'
require_relative 'lib/intake'
#require_relative 'lib/validation'
require_relative 'lib/timer'
require_relative 'lib/encode'
require_relative 'lib/auth'

app = Rack::Builder.new do
  use Timer
  use Intake
  #use Validate, 'validation!' do
    ##rule_action    param_type    param_key          param_values
    #refuse          'verb',       nil,               ['POST']
    #refuse          'path',       'encoding',        ['json','bson','xml']
    #refuse          'path',       'response_type',   ['data','bool']
    #blank           'body',       'returning',       ['yes']
    #blank           'query',      'net',             [/bs[a-z]/i]
    #drop            'header',     'content-type',    [/(application[\/]((j|b)son|xml))/i]
    #drop            'cookie',     'id',              [/[0-9a-f]{10}/i]
  #end
  use Encode
  run Auth.new
end

run app
