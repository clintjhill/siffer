module Siffer
  
  # Request represents each message received by the Server or Agent in Siffer.
  class Request < Rack::Request
    
    # Constructor will assure that #message is always populated with the body
    # of the request for easy access throughout the call.
    def initialize(env)
      env["CONTENT_TYPE"] ||= Siffer::Messaging::MIME_TYPES["appxml"]
      super(env)
    end
    
    # Provides access to the request message in Siffer::Messages::Message 
    # format.
    def message
      if body.is_a?(StringIO) && body.pos == body.length
        body.rewind
      end
      Siffer::Messages::RequestBody.parse(body)
    end
    alias :original :message
    
  end
  
end