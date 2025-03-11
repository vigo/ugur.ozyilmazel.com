module Rack
  class DowncaseHeaders
    def initialize(app)
      @app = app
    end

    def call(env)
      status, headers, body = @app.call(env)
      new_headers = headers.transform_keys(&:downcase)
      [status, new_headers, body]
    end
  end
end
