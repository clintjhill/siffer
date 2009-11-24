module Siffer
  module Messages
    
    # This message allows an agent to announce to the ZIS the functionality the agent will provide.
    #@see Object
    class Provision < Message
      element :provide_objects
      element :subscribe_objects
      element :publish_add_objects
      element :publish_change_objects
      element :publish_delete_objects
      element :request_objects
      element :respond_objects
    end
    
  end
end