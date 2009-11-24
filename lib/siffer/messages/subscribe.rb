module Siffer
  module Messages
    
    # Message is used to subscribe to event objects that are contained in this message
    #@see Object
    class Subscribe < Message
      element :object
    end
    
    # This message performs the opposite function of SIF_Subscribe.
    #@see Object
    class Unsubscribe < Message
      element :object
    end
    
  end
end
