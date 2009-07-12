module Siffer
  module Messages
    
    # Message is used to subscribe to event objects that are contained in this message
    class Subscribe < Message
      element :object, :type => :mandatory
    end
    
  end
end
