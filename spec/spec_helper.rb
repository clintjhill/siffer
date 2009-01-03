require File.join(File.dirname(__FILE__),"..", "lib","siffer")
require 'spec'


# Helper method to iterate all of the ACCEPTABLE_PATHS
# on the specified component(Server/Agent). Yields
# the Response object for each Request.
def for_every_path(options = {}, &block)
  component = options.delete(:on)
  Siffer::Protocol::ACCEPTABLE_PATHS.each do |name,path|
    res = Rack::MockRequest.new(component).post(path,options)
    yield res
  end
end