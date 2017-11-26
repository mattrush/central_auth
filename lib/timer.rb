# timer.rb

class Timer
  def initialize(app)
    @app = app
  end

  def call(env)
    # begin timing
    start = Time.now

    # call down
    status, headers, response = @app.call(env)

    # stop timing and calculate result
    stop = Time.now
    elapsed = stop - start

    # set header
    headers['X-Response-Time'] = elapsed.to_s

    # return
    [status, headers, response]
  end
end
