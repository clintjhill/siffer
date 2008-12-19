module Siffer
  
  class Request < Rack::Request
    
    def initialize(env)
      env["CONTENT_TYPE"] ||= Siffer::Messaging::MIME_TYPES["appxml"]
      super(env)
    end
    
    def ping?
      path_info == Siffer::Protocol::ACCEPTABLE_PATHS[:ping]
    end
    
    def status?
      path_info == Siffer::Protocol::ACCEPTABLE_PATHS[:status]
    end
    
  end
  
end