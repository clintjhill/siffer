module Siffer
  module Messages
    
    # Message for SIF_Event, used to deliver objects defined in SIF. 
    # Events represent the availability of new data object, changes to
    # or deletions of data object
    #@see EventObject
    class Event < Message
      element :object_data
    end
    
    # Message Element that holds the data object that is add/change/delete
    #@see Event
    class EventObject < AcDc::Body
      attribute :object_name
      attribute :action
    end
    
  end
end