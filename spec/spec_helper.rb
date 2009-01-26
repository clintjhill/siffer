require File.join(File.dirname(__FILE__),"..", "lib","siffer")
require 'spec'

# Configures a WEBrick server and yields URL. When passed a block
# starts and stops the server for the context. It returns what it 
# receives from the request.
def with_fake_server(app = nil)
  fake_app = app || lambda { |env| [200,{},env["rack.input"].read] }
  server = WEBrick::HTTPServer.new(:Host => '0.0.0.0',:Port => 9202)
  server.mount "/", Rack::Handler::WEBrick, fake_app
  Thread.new { server.start }
  trap(:INT) { server.shutdown }
  yield "http://localhost:9202/" if block_given?
  server.shutdown
end

# Helper method to iterate all of the ACCEPTABLE_PATHS
# on the specified component(Server/Agent). Yields
# the Response object for each Request.
def for_every_path(options = {}, &block)
  component = options.delete(:on)
  options["CONTENT_TYPE"] ||= Siffer::Messaging::MIME_TYPES["appxml"]
  Siffer::Protocol::ACCEPTABLE_PATHS.each do |name,path|
    res = Rack::MockRequest.new(component).post(path,options)
    yield res
  end
end

# Provides the minium to get a response from a Siffer::Server
def response_to(msg, &block)
  Rack::MockRequest.new(Siffer::Server.new("admin" => "none")
                    ).post("/",{
                    :input => msg, 
                    "CONTENT_TYPE" => Siffer::Messaging::MIME_TYPES["appxml"]})
end