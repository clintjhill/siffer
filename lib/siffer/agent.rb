module Siffer
  
  class Agent < Sinatra::Base
    
    set :root, File.join(File.dirname(__FILE__),"agent")
    enable :static
    set :port, 2828
    set :haml, {:format => :html5 }    
    set :agent_name, "Not Named"
    
    before do
      @agent_name = options.agent_name
    end
    
    get "/" do
      haml :index
    end
    
  end
  
end