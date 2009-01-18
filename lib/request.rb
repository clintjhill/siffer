module Siffer
  
  class Request < Rack::Request
    
    def initialize(env)
      env["CONTENT_TYPE"] ||= Siffer::Messaging::MIME_TYPES["appxml"]
      super(env)
    end
    
    # Returns the body of the request in string form. This is 
    # helpful in case you need to re-read the body over and over
    # again in the event that the body is a StringIO. 
    def message
      @msg ||= (body.respond_to?("read")) ? body.read : body
    end
  end
  
end