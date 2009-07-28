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
      msg = SystemControl.get_zone_status(@agent_name)
      # msg = Register.new(
      #          :header => @agent_name,
      #          :version => Siffer.sif_version,
      #          :mode => "Pull",
      #          :max_buffer_size => 1024,
      #          :name => @agent_name,
      #          :application => Application.new(
      #                :vendor => "h3o(software)",
      #                :version => Siffer.version,
      #                :product => "Siffer"
      #              )
      #          )
      puts msg
      raw = RestClient.post(url, msg, :content_type => 'application/xml')
      puts raw
      return_msg = Message.parse(raw)
      return_msg
    end
    
  end
  
end