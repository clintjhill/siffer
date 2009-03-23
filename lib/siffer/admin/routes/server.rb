module Siffer
  module Administration
    module Routes
      module Server
                
        get "/servers" do
          @servers = Database::Models::Server.all
          haml :'servers/index'
        end
      
        get "/servers/new" do
          haml :'servers/new'
        end
      
        post "/servers" do
          @server = Database::Models::Server.new params[:server]
          begin
            @server.save
            redirect "/servers"
          rescue
            haml :'servers/new'
          end
        end
        
        get "/servers/:id/edit" do
          @server = Database::Models::Server[params[:id]]
          haml :'servers/edit'
        end
        
        put "/servers/:id" do
          @server = Database::Models::Server[params[:id]]
          begin
            @server.update(params[:server])
            redirect "/servers"
          rescue
            haml :'servers/edit'
          end
        end
      
      end
    end
  end
end
