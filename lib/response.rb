module Siffer
  
  class Response < Rack::Response
    
     def initialize(body=[], status=200, header={}, &block)
       header["Content-Type"] = Siffer::Messaging::MIME_TYPES["appxml"]
       super(body,status,header,&block)
     end
     
  end
  
end