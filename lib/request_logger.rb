module Siffer
  class RequestLogger
    def initialize(app, log=nil)
      @app = app
      @log = log || STDERR
    end

    def call(env)
      @env = env
      log_request
      @app.call(env)
    end
    
    def log_request
      @now = Time.now
      message = Siffer::Messages::RequestBody.parse(@env["rack.input"])
      @log << %{%s request made by %s on %s at %s\n} %
        [
         message.type,
         @env["REMOTE_USER"],
         @now.strftime("%b/%d/%Y"),
         @now.strftime("%H:%M:%S")
        ]
    end
 
  end
end