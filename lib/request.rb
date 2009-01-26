module Siffer
  
  # Request represents each message received by the Server or Agent in Siffer.
  class Request < Rack::Request
    
    # Provides access to the request message in Siffer::Messages::Message 
    # format.
    def message
      if body.is_a?(StringIO) && body.pos == body.length
        body.rewind
      end
      Siffer::Messages::RequestBody.parse(body)
    end
    alias :original :message
    
    Siffer::Protocol::ACCEPTABLE_PATHS.each do |name,path|
      define_method("#{name.to_s}?") do
        message.type.downcase == name.to_s
        # The difference in these lines is the difference between allowing
        # any message to come through any PATH or forcing PATH and message
        # to match. What is better?
        # TODO: Decide on protocol validations !
        #@request.path_info == path || req_body.type.downcase == name.to_s
      end
    end
  end
  
end