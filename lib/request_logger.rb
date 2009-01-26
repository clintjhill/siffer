module Siffer
  class RequestLogger
    def initialize(app, log=nil)
      @app = app
      @log = log || STDERR
    end

    def call(env)
      @msg = env["rack.input"].read
      log_request
      env["rack.input"].rewind
      @app.call(env)
    end
    
    def log_request
      @now = Time.now
      message = Siffer::Messages::RequestBody.parse(@msg).type rescue "Unknown"
      host = Siffer::Messages::RequestBody.parse(@msg).source_id rescue "Unknown Source"
      if host.nil? or host == "" 
        host = "Unknown Source"
      end
      @log << %{%s request made by %s on %s at %s\n} %
        [
         message,
         host,
         @now.strftime("%b/%d/%Y"),
         @now.strftime("%H:%M:%S")
        ]
    end
 
  end
end