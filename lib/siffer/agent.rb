module Siffer
  
  class Agent < Sinatra::Base
    
    enable :static
        
    set :root, File.join(File.dirname(__FILE__),"agent")
    set :port, 2828
    set :haml, {:format => :html5 }    
    set :agent_name, "Not Named"
    set :zis_url, "Not Set"
    
    before do
      @agent_name = options.agent_name
      @zis_url = options.zis_url
      #redirect '/' unless registered? or request.path == "/register" or request.path == "/"
    end
    
    helpers do
      def registered?
        @zis_url != "Not Set"
      end
    end
    
    get "/" do
      haml :index
    end
    
    post "/register" do
      url = params[:zis_url]
      # reg_msg = Siffer::Messages::Register.new(
      #                                  :header => @agent_name,
      #                                  :version => "2.1",
      #                                  :mode => "Pull",
      #                                  :max_buffer_size => 1024,
      #                                  :name => @agent_name,
      #                                  :application => Siffer::Messages::Application.new(
      #                                        :vendor => "h3o(software)",
      #                                        :version => "2.3",
      #                                        :product => "Siffer"
      #                                      )
      #                                  )
      #       msg = Siffer::Messages::Message.parse(RestClient.post(url, reg_msg, :content_type => 'application/xml'))
      #       msg
    end
    
  end
  
end