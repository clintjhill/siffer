module Siffer
  
  class Response < Rack::Response
    
     def initialize(body=[], status=200, header={}, &block)
       header["Content-Type"] ||= Siffer::Messaging::MIME_TYPES["appxmlencoded"]
       super(body,status,header,&block)
     end
     
     def self.from(url,data)
       uri = URI.parse(url)
       begin
         response = Net::HTTP.start(uri.host,uri.port) { |http|
           post = Net::HTTP::Post.new(uri.path, {})
           post.body = (data.respond_to?("read")) ? data.read : data
           post.content_type = Siffer::Messaging::MIME_TYPES["appxml"]
           http.request(post)
         }
         Response.new(response.body,response.code.to_i,response.header.to_hash)
       rescue Errno::ECONNREFUSED => e
         Response.new(e.message, 500, {})
       end
     end
  end
  
end