module Siffer
  
  class Agent
    include Siffer::Protocol
    include Siffer::Messaging
    
    attr_reader :name, :host, :port
    
    def initialize(options = {})
      @name = options[:name] || "Default Agent"
      @host = options[:host] || "localhost"
      @port = options[:port] || 8300
    end
    
    def call(env)
      @request = Request.new(env)
      check_content_type_against_messaging
      check_path_against_protocol
      build_message_from_request
      @response = Response.new
      @response["Content-Type"] = MIME_TYPES["appxml"]
      @response.finish
    end
    
  end
  
end

# require 'net/http'
#    3  require 'net/https'
#    4  
#    5  http = Net::HTTP.new('profil.wp.pl', 443)
#    6  http.use_ssl = true
#    7  path = '/login.html'
#    8  
#    9  # GET request -> so the host can set his cookies
#   10  resp, data = http.get(path, nil)
#   11  cookie = resp.response['set-cookie']
#   12  
#   13  
#   14  # POST request -> logging in
#   15  data = 'serwis=wp.pl&url=profil.html&tryLogin=1&countTest=1&logowaniessl=1&login_username=blah&login_password=blah'
#   16  headers = {
#   17    'Cookie' => cookie,
#   18    'Referer' => 'http://profil.wp.pl/login.html',
#   19    'Content-Type' => 'application/x-www-form-urlencoded'
#   20  }
#   21  
#   22  resp, data = http.post(path, data, headers)
#   23  
#   24  
#   25  # Output on the screen -> we should get either a 302 redirect (after a successful login) or an error page
#   26  puts 'Code = ' + resp.code
#   27  puts 'Message = ' + resp.message
#   28  resp.each {|key, val| puts key + ' = ' + val}
#   29  puts data
