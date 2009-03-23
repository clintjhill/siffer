module Siffer
  module Administration
    module Routes
      module Agent
        
        get "/servers/:server_id/agent/:id" do
          "Server: #{params[:server_id]} Agent: #{params[:id]}"
        end
        
      end
    end
  end
end
