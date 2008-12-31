module Siffer
  
  class Request < Rack::Request
    
    def initialize(env)
      env["CONTENT_TYPE"] ||= Siffer::Messaging::MIME_TYPES["appxml"]
      super(env)
    end

  end
  
end