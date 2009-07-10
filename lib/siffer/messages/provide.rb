module Siffer
  module Messages
    
    # Element used by SIF_Provide to represent the object being provided
    #@see Provide
    class Object < Siffer::Xml::Body
      attribute :object_name
      element :extended_query_support
      element :contexts
    end
    
    # Message used to attempt registering as a provider of one or more data objects
    #@see Object
    class Provide < Message
      element :object, :type => :mandatory
    end
    
  end
end