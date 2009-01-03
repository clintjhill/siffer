module Siffer
  class RequestLogger
    def initialize(app, log=nil)
      @app = app
      @log = log || STDERR
    end

    def call(env)
      @env = env
      # Maybe there is a better way to pick the body of the input
      # instead of reading it then stuffing it back in ??
      @msg = env["rack.input"].read
      log_request
      env["rack.input"] = StringIO.new(@msg)
      @app.call(env)
    end
    
    def log_request
      @now = Time.now
      message = Siffer::Messages::RequestBody.parse(@msg)
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