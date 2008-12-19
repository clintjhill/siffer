module Siffer
  module Protocol
    
    def check_path_against_protocol
      unless ACCEPTABLE_PATHS.values.include? @request.path_info
        raise "Unknown path"
      end
      
      unless @request.post? 
        raise "Only POST method allowed"
      end
    end

    ACCEPTABLE_PATHS = {
      :root => "/",
      :ping => "/ping",
      :status => "/status"
    }
  
  end
end