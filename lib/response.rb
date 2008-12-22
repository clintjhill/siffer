module Siffer
  
  class Response < Rack::Response
    
     def initialize(body=[], status=200, header={}, &block)
       header["Content-Type"] ||= Siffer::Messaging::MIME_TYPES["appxml"]
       super(body,status,header,&block)
     end
     
     def self.from(url,data)
       uri = URI.parse(url)
       response = Net::HTTP.start(uri.host,uri.port) { |http|
         post = Net::HTTP::Post.new(uri.path, {})
         post.body = data
         post.content_type = Siffer::Messaging::MIME_TYPES["appxml"]
         http.request(post)
       }
       Response.new(response.body,response.code.to_i,response.header.to_hash)
     end
  end
  
end
